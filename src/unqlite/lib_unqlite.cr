@[Link("unqlite")]
lib LibUnQLite
  alias StringT = UInt8*
  alias UnQLite_Int64 = Int64

  # Database Engine Handle
  fun unqlite_open(ppDB : UnQLiteT*, zFilename : StringT, iMode : UInt32) : Int32
  fun unqlite_config(pDb : UnQLiteT, nOp : Int32, ...) : Int32
  fun unqlite_close(pDb : UnQLiteT) : Int32

  # Key/Value (KV) Store Interfaces
  fun unqlite_kv_store(pDb : UnQLiteT, pKey : Void*, nKeyLen : Int32, pData : Void*, nDataLen : UnQLite_Int64) : Int32
  fun unqlite_kv_append(pDb : UnQLiteT, pKey : Void*, nKeyLen : Int32, pData : Void*, nDataLen : UnQLite_Int64) : Int32
  fun unqlite_kv_store_fmt(pDb : UnQLiteT, pKey : Void*, nKeyLen : Int32, zFormat : StringT, ...) : Int32
  fun unqlite_kv_append_fmt(pDb : UnQLiteT, pKey : Void*, nKeyLen : Int32, zFormat : StringT, ...) : Int32
  fun unqlite_kv_fetch(pDb : UnQLiteT, pKey : Void*, nKeyLen : Int32, pBuf : Void*, pBufLen : UnQLite_Int64*) : Int64
  fun unqlite_kv_fetch_callback(pDb : UnQLiteT, pKey : Void*, nKeyLen : Int32, xConsumer : (Void*, UInt32, Void*) -> Int32, pUserData : Void*) : Int32
  fun unqlite_kv_delete(pDb : UnQLiteT, pKey : Void*, nKeyLen : Int32) : Int32
  fun unqlite_kv_config(pDb : UnQLiteT, nOp : Int32, ...) : Int32

  # Document (JSON) Store Interfaces powered by the Jx9 Scripting Language
  fun unqlite_compile(pDb : UnQLiteT, zJx9 : StringT, nByte : Int32, ppOut : UnQLiteVm*) : Int32
  fun unqlite_compile_file(pDb : UnQLiteT, zPath : StringT, ppOut : UnQLiteVm*) : Int32
  fun unqlite_vm_config(pVm : UnQLiteVm, iOp : Int32, ...) : Int32
  fun unqlite_vm_exec(pVm : UnQLiteVm) : Int32
  fun unqlite_vm_reset(pVm : UnQLiteVm) : Int32
  fun unqlite_vm_release(pVm : UnQLiteVm) : Int32
  fun unqlite_vm_dump(pVm : UnQLiteVm, xConsumer : (Void*, UInt32, Void*) -> Int32, pUserData : Void*) : Int32
  fun unqlite_vm_extract_variable(pVm : UnQLiteVm, zVarname : StringT) : UnQLiteValue

  # Cursor Iterator Interfaces
  fun unqlite_kv_cursor_init(pDb : UnQLiteT, ppOut : UnQLiteKvCursor*) : Int32
  fun unqlite_kv_cursor_release(pDb : UnQLiteT, pCur : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_seek(pCursor : UnQLiteKvCursor, pKey : Void*, nKeyLen : Int32, iPos : Int32) : Int32
  fun unqlite_kv_cursor_first_entry(pCursor : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_last_entry(pCursor : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_valid_entry(pCursor : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_next_entry(pCursor : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_prev_entry(pCursor : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_key(pCursor : UnQLiteKvCursor, pBuf : Void*, pnByte : Int32*) : Int32
  fun unqlite_kv_cursor_key_callback(pCursor : UnQLiteKvCursor, xConsumer : (Void*, UInt32, Void*) -> Int32, pUserData : Void*) : Int32
  fun unqlite_kv_cursor_data(pCursor : UnQLiteKvCursor, pBuf : Void*, pnData : UnQLite_Int64*) : Int32
  fun unqlite_kv_cursor_data_callback(pCursor : UnQLiteKvCursor, xConsumer : (Void*, UInt32, Void*) -> Int32, pUserData : Void*) : Int32
  fun unqlite_kv_cursor_delete_entry(pCursor : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_reset(pCursor : UnQLiteKvCursor) : Int32

  # Manual Transaction Manager
  fun unqlite_begin(pDb : UnQLiteT) : Int32
  fun unqlite_commit(pDb : UnQLiteT) : Int32
  fun unqlite_rollback(pDb : UnQLiteT) : Int32

  # Utility interfaces
  fun unqlite_util_load_mmaped_file(zFile : StringT, ppMap : Void**, pFileSize : UnQLite_Int64) : Int32
  fun unqlite_util_release_mmaped_file(pMap : Void*, iFileSize : UnQLite_Int64) : Int32
  fun unqlite_util_random_string(pDb : UnQLiteT, zBuf : StringT, buf_size : UInt32) : Int32
  fun unqlite_util_random_num(pDb : UnQLiteT) : UInt32

  # In-process extending interfaces
  fun unqlite_create_function(pVm : UnQLiteVm, zName : StringT, xFunc : (UnQLiteContext*, Int32, UnQLiteValue**) -> Int32, pUserData : Void*) : Int32
  fun unqlite_delete_function(pVm : UnQLiteVm, zName : StringT) : Int32
  fun unqlite_create_constant(pVm : UnQLiteVm, zName : StringT, xExpand : (UnQLiteValue*, Void*) -> NoReturn, pUserData : Void*) : Int32
  fun unqlite_delete_constant(pVm : UnQLiteVm, zName : StringT) : Int32
end
