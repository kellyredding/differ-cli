# DifferCLI

This is just a trivial CLI wrapper to the Differ API.  I wrote it
for me, tailored to my needs.

## Usage

When the gem installs, it installs a bin called 'differ'.  Use --help
to see some available options.  Have fun.

```sh
$ differ --help
$ differ "something change" "something changed here"
```

## Installation

This is a ruby gem but I'm not pushing it to rubygems.org b/c it is
so customized for what I need.  To install, just clone the repo and
run 'rake install'

```sh
$ git clone
$ rake install
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
