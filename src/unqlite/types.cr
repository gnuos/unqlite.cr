module UnQLite
  class Error < Exception
  end

  class NotFound < Error
    getter key

    def initialize(@key : String)
      super("Not Found: '#{@key}'")
    end

    def initialize(@key : Bytes)
      super("Not Found: '#{@key}'")
    end
  end
end
