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
end
