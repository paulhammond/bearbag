# bearbag

bearbag exports markdown files from [Bear](https://bear.app). I use it to copy
my notes into a git repository, giving me backups and version history. Unlike
other solutions listed below the sync is strictly one way; bearbag does not
modify notes or write to the Bear database.

## Installing

Using [Homebrew](http://brew.sh/):

```
brew install paulhammond/tap/bearbag
```

## Using

Export your bear notes to `path/to/directory`:

```
bearbag path/to/directory
```

Get help:

```
bearbag --help
```

## Alternatives

 * [Bear-Markdown-Export](https://github.com/markgrovs/Bear-Markdown-Export):
   This has a lot more options and functionality, including two way sync,
   exporting images & textbundles, and others. The two way sync scares me (which
   is why I don't use it) but if you're OK with that it enables some interesting
   use cases, such as the neat
   [Backlink Janitor](https://github.com/andymatuschak/note-link-janitor)
 * [bearc](https://github.com/hoemoon/bearc): This requires you to pick which
   tags are exported.

## Other Bear CLI tools

 * [bearing](https://github.com/carlo/bearing): a scripting helper for Bear
 * [cub](https://github.com/a5huynh/cub-cli): command-line utility for Bear

## License

bearbag is released under the [MIT License](LICENSE.txt)

I'm sharing this code publicly to make it easier for me to install when I get a
new computer, and in the hope it is useful to others. I would love to hear about
interesting things you do with it, but I do not commit to maintain or support
the code in any way. Sorry in advance.
