module UnQLite
  class DB
    getter :db_ptr, :vm_ptr, :ret_ptr, :err_ptr

    def initialize
      @err_address = 0_u32
      @err_ptr = pointerof(@err_address).as(Pointer(UInt64))

      @db_address = uninitialized Void
      @db_ptr = pointerof(@db_address).as(Pointer(LibUnQLite::UnQLiteP))

      @vm_address = uninitialized Void
      @vm_ptr = pointerof(@vm_address).as(Pointer(LibUnQLite::UnQLiteVm))

      @ret_address = 0_u32
      @ret_ptr = pointerof(@ret_address).as(Pointer(UInt64))
    end

    def open(path : String) : Void
      check_path = ->(x : String) { if x.empty?
        f = ":mem:"
        pointerof(f).as(Pointer(UInt8))
      else
        pointerof(x).as(Pointer(UInt8))
      end }

      rc = LibUnQLite.unqlite_open(@db_ptr, check_path.call(path), FileOpenFlags::UNQLITE_OPEN_CREATE)
      if rc != StdUnQLiteReturn::UNQLITE_OK
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

      LibUnQLite.unqlite_config(@db_ptr, DbHandlerConfig::UNQLITE_CONFIG_ERR_LOG, @err_ptr, pLen)
      if pLen > 0
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
      if rc != StdUnQLiteReturn::UNQLITE_OK
        iLen = 0_u32
        pLen = Pointer(UInt32).new(iLen)

        LibUnQLite.unqlite_config(@db_ptr, DbHandlerConfig::UNQLITE_CONFIG_ERR_LOG, @err_ptr, pLen)
        if pLen > 0
          check_error!
        end

        fatal("Jx9 compile error")
      end

      rc = LibUnQLite.unqlite_vm_config(@vm_ptr, Jx9VmConfigCmd::UNQLITE_VM_CONFIG_OUTPUT, 0)
      if rc != StdUnQLiteReturn::UNQLITE_OK
        fatal(@db_ptr)
      end
    end

    def exec : Void
      rc = LibUnQLite.unqlite_vm_exec(@vm_ptr)
      if rc != StdUnQLiteReturn::UNQLITE_OK
        fatal(@db_ptr)
      end
    end

    def free
      LibUnQLite.unqlite_free(@err_ptr)
      LibUnQLite.unqlite_vm_release(@vm_ptr)
      LibUnQLite.unqlite_close(@db_ptr)
    end

    @[AlwaysInline]
    private def ensure_opened!
      raise Error.new("UnQLite DB #{@path} is closed.") if closed?
    end

    @[AlwaysInline]
    private def check_error!
      if @err_address != 0
        ptr = Pointer(UInt8).new(@err_address)
        message = String.new(ptr)
        LibUnQLite.unqlite_free(ptr)
        raise(Error.new(message))
      end
    end
  end
end
