module UnQLite
  VERSION = "0.1.0"

  enum StdPublicReturn
    # Standard return values from Symisc public interfaces
    RET_OK             = 0     # Not an error
    ERR_MEM            = (-1)  # Out of memory
    ERR_IO             = (-2)  # IO error
    ERR_EMPTY          = (-3)  # Empty field
    ERR_LOCKED         = (-4)  # Locked operation
    ERR_ORANGE         = (-5)  # Out of range value
    ERR_NOTFOUND       = (-6)  # Item not found
    ERR_LIMIT          = (-7)  # Limit reached
    ERR_MORE           = (-8)  # Need more input
    ERR_INVALID        = (-9)  # Invalid parameter
    ERR_ABORT          = (-10) # User callback request an operation abort
    ERR_EXISTS         = (-11) # Item exists
    ERR_SYNTAX         = (-12) # Syntax error
    ERR_UNKNOWN        = (-13) # Unknown error
    ERR_BUSY           = (-14) # Busy operation
    ERR_OVERFLOW       = (-15) # Stack or buffer overflow
    ERR_WILLBLOCK      = (-16) # Operation will block
    ERR_NOTIMPLEMENTED = (-17) # Operation not implemented
    ERR_EOF            = (-18) # End of input
    ERR_PERM           = (-19) # Permission error
    ERR_NOOP           = (-20) # No-op
    ERR_FORMAT         = (-21) # Invalid format
    ERR_NEXT           = (-22) # Not an error
    ERR_OS             = (-23) # System call return an error
    ERR_CORRUPT        = (-24) # Corrupted pointer
    ERR_CONTINUE       = (-25) # Not an error: Operation in progress
    ERR_NOMATCH        = (-26) # No match
    ERR_RESET          = (-27) # Operation reset
    ERR_DONE           = (-28) # Not an error
    ERR_SHORT          = (-29) # Buffer too short
    ERR_PATH           = (-30) # Path error
    ERR_TIMEOUT        = (-31) # Timeout
    ERR_BIG            = (-32) # Too big for processing
    ERR_RETRY          = (-33) # Retry your call
    ERR_IGNORE         = (-63) # Ignore
  end

  enum StdUnQLiteReturn
    # Standard UnQLite return values
    UNQLITE_OK             =   0 # Successful result
    UNQLITE_NOMEM          =  -1 # Out of memory
    UNQLITE_IOERR          =  -2 # IO error
    UNQLITE_EMPTY          =  -3 # Empty record
    UNQLITE_LOCKED         =  -4 # Forbidden Operation
    UNQLITE_NOTFOUND       =  -6 # No such record
    UNQLITE_LIMIT          =  -7 # Database limit reached
    UNQLITE_INVALID        =  -9 # Invalid parameter
    UNQLITE_ABORT          = -10 # Another thread have released this instance
    UNQLITE_EXISTS         = -11 # Record exists
    UNQLITE_UNKNOWN        = -13 # Unknown configuration option
    UNQLITE_BUSY           = -14 # The database file is locked
    UNQLITE_NOTIMPLEMENTED = -17 # Method not implemented by the underlying Key/Value storage engine
    UNQLITE_EOF            = -18 # End Of Input
    UNQLITE_PERM           = -19 # Permission error
    UNQLITE_NOOP           = -20 # No such method
    UNQLITE_CORRUPT        = -24 # Corrupt pointer
    UNQLITE_DONE           = -28 # Operation done
    UNQLITE_COMPILE_ERR    = -70 # Compilation error
    UNQLITE_VM_ERR         = -71 # Virtual machine error
    UNQLITE_FULL           = -73 # Full database (unlikely)
    UNQLITE_CANTOPEN       = -74 # Unable to open the database file
    UNQLITE_READ_ONLY      = -75 # Read only Key/Value storage engine
    UNQLITE_LOCKERR        = -76 # Locking protocol error
  end

  enum DbHandlerConfig
    # Database Handle Configuration Commands.
    UNQLITE_CONFIG_JX9_ERR_LOG         = 1 # TWO ARGUMENTS: const char **pzBuf, int *pLen
    UNQLITE_CONFIG_MAX_PAGE_CACHE      = 2 # ONE ARGUMENT: int nMaxPage
    UNQLITE_CONFIG_ERR_LOG             = 3 # TWO ARGUMENTS: const char **pzBuf, int *pLen
    UNQLITE_CONFIG_KV_ENGINE           = 4 # ONE ARGUMENT: const char *zKvName
    UNQLITE_CONFIG_DISABLE_AUTO_COMMIT = 5 # NO ARGUMENTS
    UNQLITE_CONFIG_GET_KV_NAME         = 6 # ONE ARGUMENT: const char **pzPtr
  end

  enum Jx9VmConfigCmd
    # UnQLite/Jx9 Virtual Machine Configuration Commands.
    UNQLITE_VM_CONFIG_OUTPUT          =  1 # TWO ARGUMENTS: int (*xConsumer)(const void *pOut, unsigned int nLen, void *pUserData), void *pUserData
    UNQLITE_VM_CONFIG_IMPORT_PATH     =  2 # ONE ARGUMENT: const char *zIncludePath
    UNQLITE_VM_CONFIG_ERR_REPORT      =  3 # NO ARGUMENTS: Report all run-time errors in the VM output
    UNQLITE_VM_CONFIG_RECURSION_DEPTH =  4 # ONE ARGUMENT: int nMaxDepth
    UNQLITE_VM_OUTPUT_LENGTH          =  5 # ONE ARGUMENT: unsigned int *pLength
    UNQLITE_VM_CONFIG_CREATE_VAR      =  6 # TWO ARGUMENTS: const char *zName, unqlite_value *pValue
    UNQLITE_VM_CONFIG_HTTP_REQUEST    =  7 # TWO ARGUMENTS: const char *zRawRequest, int nRequestLength
    UNQLITE_VM_CONFIG_SERVER_ATTR     =  8 # THREE ARGUMENTS: const char *zKey, const char *zValue, int nLen
    UNQLITE_VM_CONFIG_ENV_ATTR        =  9 # THREE ARGUMENTS: const char *zKey, const char *zValue, int nLen
    UNQLITE_VM_CONFIG_EXEC_VALUE      = 10 # ONE ARGUMENT: unqlite_value **ppValue
    UNQLITE_VM_CONFIG_IO_STREAM       = 11 # ONE ARGUMENT: const unqlite_io_stream *pStream
    UNQLITE_VM_CONFIG_ARGV_ENTRY      = 12 # ONE ARGUMENT: const char *zValue
    UNQLITE_VM_CONFIG_EXTRACT_OUTPUT  = 13 # TWO ARGUMENTS: const void **ppOut, unsigned int *pOutputLen
  end

  enum StorEngineConfigCmd
    # Storage engine configuration commands.
    UNQLITE_KV_CONFIG_HASH_FUNC = 1 # ONE ARGUMENT: unsigned int (*xHash)(const void *,unsigned int)
    UNQLITE_KV_CONFIG_CMP_FUNC  = 2 # ONE ARGUMENT: int (*xCmp)(const void *,const void *,unsigned int)
  end

  enum GlobalConfigCmd
    # Global Library Configuration Commands.
    UNQLITE_LIB_CONFIG_USER_MALLOC         = 1 # ONE ARGUMENT: const SyMemMethods *pMemMethods
    UNQLITE_LIB_CONFIG_MEM_ERR_CALLBACK    = 2 # TWO ARGUMENTS: int (*xMemError)(void *), void *pUserData
    UNQLITE_LIB_CONFIG_USER_MUTEX          = 3 # ONE ARGUMENT: const SyMutexMethods *pMutexMethods
    UNQLITE_LIB_CONFIG_THREAD_LEVEL_SINGLE = 4 # NO ARGUMENTS
    UNQLITE_LIB_CONFIG_THREAD_LEVEL_MULTI  = 5 # NO ARGUMENTS
    UNQLITE_LIB_CONFIG_VFS                 = 6 # ONE ARGUMENT: const unqlite_vfs *pVfs
    UNQLITE_LIB_CONFIG_STORAGE_ENGINE      = 7 # ONE ARGUMENT: unqlite_kv_methods *pStorage
    UNQLITE_LIB_CONFIG_PAGE_SIZE           = 8 # ONE ARGUMENT: int iPageSize
  end

  enum FileOpenFlags
    # These bit values are intended for use in the 3rd parameter to the [unqlite_open()] interface
    # and in the 4th parameter to the xOpen method of the [unqlite_vfs] object.
    UNQLITE_OPEN_READONLY        = 0x00000001 # Read only mode. Ok for [unqlite_open]
    UNQLITE_OPEN_READWRITE       = 0x00000002 # Ok for [unqlite_open]
    UNQLITE_OPEN_CREATE          = 0x00000004 # Ok for [unqlite_open]
    UNQLITE_OPEN_EXCLUSIVE       = 0x00000008 # VFS only
    UNQLITE_OPEN_TEMP_DB         = 0x00000010 # VFS only
    UNQLITE_OPEN_NOMUTEX         = 0x00000020 # Ok for [unqlite_open]
    UNQLITE_OPEN_OMIT_JOURNALING = 0x00000040 # Omit journaling for this database. Ok for [unqlite_open]
    UNQLITE_OPEN_IN_MEMORY       = 0x00000080 # An in memory database. Ok for [unqlite_open]
    UNQLITE_OPEN_MMAP            = 0x00000100 # Obtain a memory view of the whole file. Ok for [unqlite_open]
  end

  enum SyncTypeFlags
    # Synchronization Type Flags
    UNQLITE_SYNC_NORMAL   = 0x00002
    UNQLITE_SYNC_FULL     = 0x00003
    UNQLITE_SYNC_DATAONLY = 0x00010
  end

  enum FileLockLevels
    # File Locking Levels
    UNQLITE_LOCK_NONE      = 0
    UNQLITE_LOCK_SHARED    = 1
    UNQLITE_LOCK_RESERVED  = 2
    UNQLITE_LOCK_PENDING   = 3
    UNQLITE_LOCK_EXCLUSIVE = 4
  end
end
