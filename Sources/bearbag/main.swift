import Foundation
import SQLite

let home = NSHomeDirectory()
let db = try Connection(
  "\(home)/Library/Group Containers/9K33E3U3T4.net.shinyfrog.bear/Application Data/database.sqlite",
  readonly: true)

let outputDir = URL(fileURLWithPath: "\(home)/tmp/bearbag")

if !FileManager.default.fileExists(atPath: outputDir.path) {
  print("creating export directory \(outputDir.path)")
  try FileManager.default.createDirectory(
    at: outputDir, withIntermediateDirectories: true, attributes: nil)
} else {
  print("exporting to directory \(outputDir.path)")

}

let notes = Table("ZSFNOTE")

let count = try db.scalar(notes.count)
print("db has \(count) notes")

let title = Expression<String>("ZTITLE")
let text = Expression<String>("ZTEXT")
let creation = Expression<Date>("ZCREATIONDATE")
for note in try db.prepare(notes.select(title, text).order(creation.desc)) {

  let clean = note[title]
    .trimmingCharacters(in: .whitespaces)
    .replacingOccurrences(of: "\\W", with: "-", options: .regularExpression)
    .replacingOccurrences(of: "-+", with: "-", options: .regularExpression)
    .lowercased()
    .prefix(100)

  let fileURL = outputDir.appendingPathComponent("\(clean).md")
  print("title: \(note[title]) \(fileURL)")

  try note[text].write(
    to: fileURL,
    atomically: true,
    encoding: .utf8
  )
}
