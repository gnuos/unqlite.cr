@[Link("unqlite")]
lib LibUnQLite
  alias VoidP = Pointer(Void)
  alias StringP = Pointer(UInt8)

  alias UnQLiteP = Pointer(Void)
  alias UnQLiteVm = Pointer(Void)
  alias UnQLiteFile = Pointer(Void)
  alias UnQLiteIOMethods = Pointer(Void)
  alias UnQLiteVfs = Pointer(Void)
  alias UnQLitePage = Pointer(Void)
  alias UnQLiteKvHandle = Pointer(Void)
  alias UnQLiteKvIO = Pointer(Void)
  alias UnQLiteKvCursor = Pointer(Void)
  alias UnQLiteKvEngine = Pointer(Void)
  alias UnQLiteKvMethods = Pointer(Void)
  alias UnQLiteValue = Pointer(Void)
  alias UnQLiteContext = Pointer(Void)
  alias UnQLiteIoStream = Pointer(Void)
  alias UnQLite_Int64 = Int64

  # Database Engine Handle
  fun unqlite_open(ppDB : Pointer(UnQLiteP), zFilename : StringP, iMode : UInt32) : Int32
  fun unqlite_config(pDb : UnQLiteP, nOp : Int32, ...) : Int32
  fun unqlite_close(pDb : UnQLiteP) : Int32

  # Key/Value (KV) Store Interfaces
  fun unqlite_kv_store(pDb : UnQLiteP, pKey : VoidP, nKeyLen : Int32, pData : VoidP, nDataLen : UnQLite_Int64) : Int32
  fun unqlite_kv_append(pDb : UnQLiteP, pKey : VoidP, nKeyLen : Int32, pData : VoidP, nDataLen : UnQLite_Int64) : Int32
  fun unqlite_kv_store_fmt(pDb : UnQLiteP, pKey : VoidP, nKeyLen : Int32, zFormat : StringP, ...) : Int32
  fun unqlite_kv_append_fmt(pDb : UnQLiteP, pKey : VoidP, nKeyLen : Int32, zFormat : StringP, ...) : Int32
  fun unqlite_kv_fetch(pDb : UnQLiteP, pKey : VoidP, nKeyLen : Int32, pBuf : VoidP, pBufLen : UnQLite_Int64*) : Int64
  fun unqlite_kv_fetch_callback(pDb : UnQLiteP, pKey : VoidP, nKeyLen : Int32, xConsumer : (VoidP, UInt32, VoidP) -> Int32, pUserData : VoidP) : Int32
  fun unqlite_kv_delete(pDb : UnQLiteP, pKey : VoidP, nKeyLen : Int32) : Int32
  fun unqlite_kv_config(pDb : UnQLiteP, nOp : Int32, ...) : Int32

  # Document (JSON) Store Interfaces powered by the Jx9 Scripting Language
  fun unqlite_compile(pDb : UnQLiteP, zJx9 : StringP, nByte : Int32, ppOut : UnQLiteVm*) : Int32
  fun unqlite_compile_file(pDb : UnQLiteP, zPath : StringP, ppOut : UnQLiteVm*) : Int32
  fun unqlite_vm_config(pVm : UnQLiteVm, iOp : Int32, ...) : Int32
  fun unqlite_vm_exec(pVm : UnQLiteVm) : Int32
  fun unqlite_vm_reset(pVm : UnQLiteVm) : Int32
  fun unqlite_vm_release(pVm : UnQLiteVm) : Int32
  fun unqlite_vm_dump(pVm : UnQLiteVm, xConsumer : (VoidP, UInt32, VoidP) -> Int32, pUserData : VoidP) : Int32
  fun unqlite_vm_extract_variable(pVm : UnQLiteVm, zVarname : StringP) : UnQLiteValue

  # Cursor Iterator Interfaces
  fun unqlite_kv_cursor_init(pDb : UnQLiteP, ppOut : UnQLiteKvCursor*) : Int32
  fun unqlite_kv_cursor_release(pDb : UnQLiteP, pCur : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_seek(pCursor : UnQLiteKvCursor, pKey : VoidP, nKeyLen : Int32, iPos : Int32) : Int32
  fun unqlite_kv_cursor_first_entry(pCursor : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_last_entry(pCursor : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_valid_entry(pCursor : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_next_entry(pCursor : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_prev_entry(pCursor : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_key(pCursor : UnQLiteKvCursor, pBuf : VoidP, pnByte : Int32*) : Int32
  fun unqlite_kv_cursor_key_callback(pCursor : UnQLiteKvCursor, xConsumer : (VoidP, UInt32, VoidP) -> Int32, pUserData : VoidP) : Int32
  fun unqlite_kv_cursor_data(pCursor : UnQLiteKvCursor, pBuf : VoidP, pnData : UnQLite_Int64*) : Int32
  fun unqlite_kv_cursor_data_callback(pCursor : UnQLiteKvCursor, xConsumer : (VoidP, UInt32, VoidP) -> Int32, pUserData : VoidP) : Int32
  fun unqlite_kv_cursor_delete_entry(pCursor : UnQLiteKvCursor) : Int32
  fun unqlite_kv_cursor_reset(pCursor : UnQLiteKvCursor) : Int32

  # Manual Transaction Manager
  fun unqlite_begin(pDb : UnQLiteP) : Int32
  fun unqlite_commit(pDb : UnQLiteP) : Int32
  fun unqlite_rollback(pDb : UnQLiteP) : Int32

  # Utility interfaces
  fun unqlite_util_load_mmaped_file(zFile : StringP, ppMap : VoidP, pFileSize : UnQLite_Int64) : Int32
  fun unqlite_util_release_mmaped_file(pMap : VoidP, iFileSize : UnQLite_Int64) : Int32
  fun unqlite_util_random_string(pDb : UnQLiteP, zBuf : StringP, buf_size : UInt32) : Int32
  fun unqlite_util_random_num(pDb : UnQLiteP) : UInt32

  # In-process extending interfaces
  fun unqlite_create_function(pVm : UnQLiteVm, zName : StringP, xFunc : (UnQLiteContext*, Int32, UnQLiteValue**) -> Int32, pUserData : VoidP) : Int32
  fun unqlite_delete_function(pVm : UnQLiteVm, zName : StringP) : Int32
  fun unqlite_create_constant(pVm : UnQLiteVm, zName : StringP, xExpand : (UnQLiteValue*, VoidP) -> NoReturn, pUserData : VoidP) : Int32
  fun unqlite_delete_constant(pVm : UnQLiteVm, zName : StringP) : Int32

  # On Demand Object allocation interfaces
  fun unqlite_vm_new_scalar(pVm : UnQLiteVm) : UnQLiteValue
  fun unqlite_vm_new_array(pVm : UnQLiteVm) : UnQLiteValue
  fun unqlite_vm_release_value(pVm : UnQLiteVm, pValue : UnQLiteValue) : Int32
  fun unqlite_context_new_scalar(pCtx : UnQLiteContext) : UnQLiteValue
  fun unqlite_context_new_array(pCtx : UnQLiteContext) : UnQLiteValue
  fun unqlite_context_release_value(pCtx : UnQLiteContext, pValue : UnQLiteValue) : NoReturn

  # Dynamically Typed Value Object Management Interfaces
  fun unqlite_value_int(pVal : UnQLiteValue, iValue : UnQLiteValue) : Int32
  fun unqlite_value_int64(pVal : UnQLiteValue, iValue : UnQLite_Int64) : Int32
  fun unqlite_value_bool(pVal : UnQLiteValue, iBool : Int32) : Int32
  fun unqlite_value_null(pVal : UnQLiteValue) : Int32
  fun unqlite_value_double(pVal : UnQLiteValue, value : Float64) : Int32
  fun unqlite_value_string(pVal : UnQLiteValue, zString : StringP, nLen : Int32) : Int32
  fun unqlite_value_string_format(pVal : UnQLiteValue, zFormat : StringP, ...) : Int32
  fun unqlite_value_reset_string_cursor(pVal : UnQLiteValue) : Int32
  fun unqlite_value_resource(pVal : UnQLiteValue, pUserData : VoidP) : Int32
  fun unqlite_value_release(pVal : UnQLiteValue) : Int32

  # Foreign Function Parameter Values
  fun unqlite_value_to_int(pValue : UnQLiteValue) : Int32
  fun unqlite_value_to_bool(pValue : UnQLiteValue) : Int32
  fun unqlite_value_to_int64(pValue : UnQLiteValue) : UnQLite_Int64
  fun unqlite_value_to_double(pValue : UnQLiteValue) : Float64
  fun unqlite_value_to_string(pValue : UnQLiteValue, pLen : Int32*) : StringP
  fun unqlite_value_to_resource(pValue : UnQLiteValue) : VoidP
  fun unqlite_value_compare(pLeft : UnQLiteValue, pRight : UnQLiteValue, bStrict : Int32) : Int32

  # Setting The Result Of A Foreign Function
  fun unqlite_result_int(pCtx : UnQLiteContext, iValue : Int32) : Int32
  fun unqlite_result_int64(pCtx : UnQLiteContext, iValue : UnQLite_Int64) : Int32
  fun unqlite_result_bool(pCtx : UnQLiteContext, iBool : Int32) : Int32
  fun unqlite_result_double(pCtx : UnQLiteContext, value : Float64) : Int32
  fun unqlite_result_null(pCtx : UnQLiteContext) : Int32
  fun unqlite_result_string(pCtx : UnQLiteContext, zString : StringP, nLen : Int32) : Int32
  fun unqlite_result_string_format(pCtx : UnQLiteContext, zFormat : StringP, ...) : Int32
  fun unqlite_result_value(pCtx : UnQLiteContext, pValue : UnQLiteValue) : Int32
  fun unqlite_result_resource(pVal : UnQLiteValue, pUserData : VoidP) : Int32

  # Dynamically Typed Value Object Query Interfaces
  fun unqlite_value_is_int(pVal : UnQLiteValue) : Int32
  fun unqlite_value_is_float(pVal : UnQLiteValue) : Int32
  fun unqlite_value_is_bool(pVal : UnQLiteValue) : Int32
  fun unqlite_value_is_string(pVal : UnQLiteValue) : Int32
  fun unqlite_value_is_null(pVal : UnQLiteValue) : Int32
  fun unqlite_value_is_numeric(pVal : UnQLiteValue) : Int32
  fun unqlite_value_is_callable(pVal : UnQLiteValue) : Int32
  fun unqlite_value_is_scalar(pVal : UnQLiteValue) : Int32
  fun unqlite_value_is_json_array(pVal : UnQLiteValue) : Int32
  fun unqlite_value_is_json_object(pVal : UnQLiteValue) : Int32
  fun unqlite_value_is_resource(pVal : UnQLiteValue) : Int32
  fun unqlite_value_is_empty(pVal : UnQLiteValue) : Int32

  # JSON Array/Object Management Interfaces
  fun unqlite_array_fetch(pArray : UnQLiteValue, zKey : StringP, nByte : Int32) : UnQLiteValue
  fun unqlite_array_walk(pArray : UnQLiteValue, xWalk : (UnQLiteValue, UnQLiteValue, VoidP) -> Int32*, pUserData : VoidP) : Int32
  fun unqlite_array_add_elem(pArray : UnQLiteValue, pKey : UnQLiteValue, pValue : UnQLiteValue) : Int32
  fun unqlite_array_add_strkey_elem(pArray : UnQLiteValue, zKey : StringP, pValue : UnQLiteValue) : Int32
  fun unqlite_array_count(pArray : UnQLiteValue) : Int32

  # Call Context Handling Interfaces
  fun unqlite_context_output(pCtx : UnQLiteContext, zString : StringP, nLen : Int32) : Int32
  fun unqlite_context_output_format(pCtx : UnQLiteContext, zFormat : StringP) : Int32
  fun unqlite_context_throw_error(pCtx : UnQLiteContext, iErr : Int32, zErr : StringP) : Int32
  fun unqlite_context_throw_error_format(pCtx : UnQLiteContext, iErr : Int32, zFormat : StringP, ...) : Int32
  fun unqlite_context_random_num(pCtx : UnQLiteContext) : UInt32
  fun unqlite_context_random_string(pCtx : UnQLiteContext, zBuf : StringP, nBuflen : Int32) : Int32
  fun unqlite_context_user_data(pCtx : UnQLiteContext) : VoidP
  fun unqlite_context_push_aux_data(pCtx : UnQLiteContext, pUserData : VoidP) : Int32
  fun unqlite_context_peek_aux_data(pCtx : UnQLiteContext) : VoidP
  fun unqlite_context_result_buf_length(pCtx : UnQLiteContext) : UInt32
  fun unqlite_function_name(pCtx : UnQLiteContext) : StringP

  # Call Context Memory Management Interfaces
  fun unqlite_context_alloc_chunk(pCtx : UnQLiteContext, nByte : UInt32, zeroChunk : Int32, autoRelease : Int32) : VoidP
  fun unqlite_context_realloc_chunk(pCtx : UnQLiteContext, pChunk : VoidP, nByte : UInt32) : VoidP
  fun unqlite_context_free_chunk(pCtx : UnQLiteContext, pChunk : VoidP) : NoReturn

  # Global Library Management Interfaces
  fun unqlite_lib_config(nConfigOp : Int32) : Int32
  fun unqlite_lib_init : Int32
  fun unqlite_lib_shutdown : Int32
  fun unqlite_lib_is_threadsafe : Int32
  fun unqlite_lib_version : StringP
  fun unqlite_lib_signature : StringP
  fun unqlite_lib_ident : StringP
  fun unqlite_lib_copyright : StringP
end
