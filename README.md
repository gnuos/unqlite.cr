# unqlite.cr

使用Crystal编写的UnQLite数据库的C绑定

## Installation

如果要使用这个库，需要添加以下代码到你的 `shard.yml` 文件中:

```yaml
dependencies:
  unqlite:
    github: gnuos/unqlite.cr
```

## Usage

```crystal
require "unqlite"
```

在代码中使用使用上面的语句导入 `unqlite` 包可以使用 unqlite 数据库，但是一定要先安装 `libunqlite`，否则无法编译成功。

## Development

还有一些API没有封装起来，如果有需要的话，请先阅读 unqlite 数据库的官方介绍。如果需要一些新的封装，你可以通过以下方式加入进来。

## Contributing

1. Fork it ( https://github.com/[your-github-name]/unqlite/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [gnuos](https://github.com/gnuos) Kevin - creator, maintainer

