import ArgumentParser
import BearBagCore
import Foundation
import SQLite

struct Bearbag: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "A bear export utility"
  )

  @Option(name: .customLong("db"), help: .hidden)
  var dbPath =
    "\(NSHomeDirectory())/Library/Group Containers/9K33E3U3T4.net.shinyfrog.bear/Application Data/database.sqlite"

  @Argument(help: "Output directory")
  var output: String

  mutating func run() throws {
    let db = try Connection(
      dbPath,
      readonly: true)

    let outputURL = URL(fileURLWithPath: output)
    let imgURL = URL(fileURLWithPath: dbPath)
      .deletingLastPathComponent()
      .appendingPathComponent("/Local Files/Note Images")

    let noteTable = Table("ZSFNOTE")

    let count = try db.scalar(noteTable.count)
    print("db has \(count) notes")

    let uuid = Expression<String>("ZUNIQUEIDENTIFIER")
    let title = Expression<String>("ZTITLE")
    let text = Expression<String>("ZTEXT")
    let creation = Expression<Date>("ZCREATIONDATE")
    let trashed = Expression<Int>("ZTRASHED")
    let deleted = Expression<Int>("ZPERMANENTLYDELETED")

    for row in try db.prepare(
      noteTable.select(uuid, title, text, deleted, trashed).where(deleted == 0 && trashed == 0)
        .order(creation.desc))
    {
      let note = Note(
        uuid: row[uuid],
        title: row[title],
        text: row[text]
      )

      let fileURL = outputURL.appendingPathComponent(note.path)

      try mkdir(fileURL.deletingLastPathComponent())

      for (src, dst) in note.images {

        let dstURL = outputURL.appendingPathComponent(dst)
        let srcURL = imgURL.appendingPathComponent(src)

        print("writing: \(dstURL.path)")
        try mkdir(dstURL.deletingLastPathComponent())
        if FileManager.default.fileExists(atPath: dstURL.path) {
          try FileManager.default.removeItem(at: dstURL)
        }
        try FileManager.default.copyItem(at: srcURL, to: dstURL)
      }

      print("writing: \(fileURL.path)")
      try note.markdown.write(
        to: fileURL,
        atomically: true,
        encoding: .utf8
      )
    }
  }

  func mkdir(_ dir: URL) throws {
    if !FileManager.default.fileExists(atPath: dir.path) {
      print("creating directory \(dir.path)")
      try FileManager.default.createDirectory(
        at: dir, withIntermediateDirectories: true, attributes: nil)
    }
  }

}

Bearbag.main()
