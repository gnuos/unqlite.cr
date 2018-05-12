module UnQLite
  class DB
    getter :db_ptr, :vm_ptr, :ret_ptr, :err_ptr

    def initialize
      @err_ptr = uninitialized LibUnQLite::StringP

      @db_ptr = uninitialized LibUnQLite::UnQLiteP

      @vm_ptr = uninitialized LibUnQLite::UnQLiteVm

      @ret_ptr = uninitialized Void*
    end

    def open(path : String) : Void
      check_path = ->(x : String) { if x.empty?
        f = ":mem:"
        pointerof(f).as(Pointer(UInt8))
      else
        pointerof(x).as(Pointer(UInt8))
      end }

      ppDb = pointerof(@db_ptr).as(Pointer(LibUnQLite::UnQLiteP))
      rc = LibUnQLite.unqlite_open(ppDb, check_path.call(path), FileOpenFlags::UNQLITE_OPEN_CREATE.value)
      if rc != StdUnQLiteReturn::UNQLITE_OK.value
        fatal("Out of memory")
      end
      @opened = true
    end

    def opened? : Bool
      @opened || false
    end

    def close : Void
      if closed?
        free
        @opened = false
      end
    end

    def closed? : Bool
      !opened?
    end

    def fatal(pDb : LibUnQLite::UnQLiteP) : NoReturn
      iLen = 0_u32
      pLen = Pointer(UInt32).new(iLen)

      LibUnQLite.unqlite_config(@db_ptr, DbHandlerConfig::UNQLITE_CONFIG_ERR_LOG.value, @err_ptr, pLen)
      if pLen.value > 0
        check_error!
      end

      LibUnQLite.unqlite_lib_shutdown
      exit(1)
    end

    def fatal(zMsg : String) : NoReturn
      if !zMsg.empty?
        puts zMsg
      end

      LibUnQLite.unqlite_lib_shutdown
      exit(1)
    end

    def compile(script : String) : Void
      rc = LibUnQLite.unqlite_compile(@db_ptr, script, UInt32.new(script.bytesize), pointerof(@vm_ptr))
      if rc != StdUnQLiteReturn::UNQLITE_OK.value
        iLen = 0_u32
        pLen = Pointer(UInt32).new(iLen)

        LibUnQLite.unqlite_config(@db_ptr, DbHandlerConfig::UNQLITE_CONFIG_ERR_LOG.value, @err_ptr, pLen)
        if pLen.value > 0
          check_error!
        end

        fatal("Jx9 compile error")
      end

      rc = LibUnQLite.unqlite_vm_config(@vm_ptr, Jx9VmConfigCmd::UNQLITE_VM_CONFIG_OUTPUT.value, 0)
      if rc != StdUnQLiteReturn::UNQLITE_OK.value
        fatal(@db_ptr)
      end
    end

    def exec : Void
      rc = LibUnQLite.unqlite_vm_exec(@vm_ptr)
      if rc != StdUnQLiteReturn::UNQLITE_OK.value
        fatal(@db_ptr)
      end
    end

    def free
      LibUnQLite.unqlite_vm_release(@vm_ptr)
      LibUnQLite.unqlite_close(@db_ptr)
    end

    @[AlwaysInline]
    private def ensure_opened!
      raise Error.new("UnQLite DB #{@path} is closed.") if closed?
    end

    @[AlwaysInline]
    private def check_error!
      message = String.new(@err_ptr)
      raise(Error.new(message))
    end
  end
end
