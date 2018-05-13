module UnQLite::Api
  private macro api(name)
    def {{name.id}}(*args)
        LibUnQLite.{{name.id}}(*args)
    end
  end

  private macro try(name)
    def {{name.id}}(*args)
        LibUnQLite.{{name.id}}(*args).tap { |x|
          raise UnQLite::Error.new("ERR: {{name}} failed.") if x != 0
        }
    end
  end

  try unqlite_open
  api unqlite_config
  api unqlite_close
  api unqlite_compile
  api unqlite_compile_file
  api unqlite_vm_config
  try unqlite_vm_exec
  api unqlite_vm_reset
  api unqlite_vm_release
  api unqlite_vm_dump

  try unqlite_begin
  try unqlite_commit
  try unqlite_rollback

  api unqlite_lib_config
  api unqlite_lib_init
  api unqlite_lib_shutdown
  api unqlite_lib_is_threadsafe
  api unqlite_lib_version
end
