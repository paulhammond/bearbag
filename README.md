# bearbag

bearbag was a markdown exporter for [Bear][]. I used it to copy my notes into a
git repository, giving me backups and version history.

**⚠️ bearbag is unmaintained.** [Bear 2.8][] now includes a built-in
[bearcli][] tool, which provides all of the functionality needed to export notes
and attachments, especially when wrapped in a small shell script. I recommend
you use that instead.

[Bear]: https://bear.app/
[Bear 2.8]: https://blog.bear.app/2026/04/bear-2-8-bearcli-claude-connector-and-mcp-server/
[bearcli]: https://bear.app/faq/command-line-interface/

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
