module UnQLite
  class DB
    getter :db_ptr, :vm_ptr, :ret_ptr, :err_ptr

    def initialize(@path : String, create_if_missing : Bool = true)
      @err_address = 0_u32
      @err_ptr = pointerof(@err_address).as(Pointer(UInt64))

      @db_address = uninitialized Void
      @db_ptr = pointerof(@db_address).as(Pointer(Void))

      @ret_address = 0_u32
      @ret_ptr = pointerof(@ret_address).as(Pointer(UInt32))
    end

    def open : Int32
      if path.empty?
        LibUnQLite.unqlite_open(@db_ptr, ":mem:", LibUnQLite.UNQLITE_OPEN_CREATE)
      end
      LibUnQLite.unqlite_open(@db_ptr, @path, LibUnQLite.UNQLITE_OPEN_CREATE)
    end

    def opened? : Bool
      @opened
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
        LibLevelDB.unqlite_free(ptr)
        raise(Error.new(message))
      end
    end
  end
end
