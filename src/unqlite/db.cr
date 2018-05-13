class UnQLite::DB
  include Api

  property db_ptr : LibUnQLite::UnQLiteP
  property vm_ptr : LibUnQLite::UnQLiteVm
  property err_ptr : LibUnQLite::StringP
  property ret_ptr : Pointer(Void)

  def initialize(@path : String)
    @err_ptr = LibUnQLite::StringP.malloc(1_u64)
    @db_ptr = LibUnQLite::UnQLiteP.malloc(1_u64)
    @vm_ptr = LibUnQLite::UnQLiteVm.malloc(1_u64)
    @ret_ptr = Pointer(Void).malloc(1_u64)

    rc = unqlite_open(pointerof(@db_ptr), @path, FileOpenFlags::UNQLITE_OPEN_CREATE.value)
    if rc != StdUnQLiteReturn::UNQLITE_OK.value
      fatal("Out of memory")
    end
    @opened = true
  end

  def opened?
    @opened || false
  end

  def closed?
    !@opened
  end

  def close
    if opened?
      free
      @opened = false
    end
  end

  protected def free
    unqlite_vm_release(@vm_ptr)
    unqlite_close(@db_ptr)
  end

  protected def clue
    @path
  end

  def prepare(script : String) : Void
    rc = unqlite_compile(@db_ptr, script, UInt32.new(script.bytesize), pointerof(@vm_ptr))
    if rc != StdUnQLiteReturn::UNQLITE_OK.value
      iLen = 0_u32
      pLen = Pointer(UInt32).new(iLen)

      unqlite_config(@db_ptr, DbHandlerConfig::UNQLITE_CONFIG_ERR_LOG.value, @err_ptr, pLen)
      if pLen.value > 0
        check_error!
      end

      fatal("Jx9 compile error")
    end
  end

  def config(callback : (Pointer(Void), UInt32, Pointer(Void)) -> Int32) : Void
    rc = unqlite_vm_config(@vm_ptr, Jx9VmConfigCmd::UNQLITE_VM_CONFIG_OUTPUT.value, callback, 0)
    if rc != StdUnQLiteReturn::UNQLITE_OK.value
      fatal(@db_ptr)
    end
  end

  def execute : Void
    rc = unqlite_vm_exec(@vm_ptr)
    if rc != StdUnQLiteReturn::UNQLITE_OK.value
      fatal(@db_ptr)
    end
  end

  def fatal(pDb : LibUnQLite::UnQLiteP) : NoReturn
    iLen = 0_u32
    pLen = Pointer(UInt32).new(iLen)

    unqlite_config(@db_ptr, DbHandlerConfig::UNQLITE_CONFIG_ERR_LOG.value, @err_ptr, pLen)
    if pLen.value > 0
      check_error!
    end

    unqlite_lib_shutdown
    exit(1)
  end

  def fatal(zMsg : String) : NoReturn
    if !zMsg.empty?
      puts zMsg
    end

    unqlite_lib_shutdown
    exit(1)
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
