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

let uuid = Expression<String>("ZUNIQUEIDENTIFIER")
let title = Expression<String>("ZTITLE")
let text = Expression<String>("ZTEXT")
let creation = Expression<Date>("ZCREATIONDATE")
for note in try db.prepare(notes.select(uuid, title, text).order(creation.desc)) {

  var path = cleanTitle(note[title])
  let dir = getDir(note[text])
  if dir != nil {
    path = "\(dir!)/\(path)"
  }

  let fileURL = outputDir.appendingPathComponent("\(path).md")
  print("writing: \(fileURL.path)")

  let md = processContent(uuid: note[uuid], contents: note[text])
  try mkdir(fileURL.deletingLastPathComponent())
  try md.write(
    to: fileURL,
    atomically: true,
    encoding: .utf8
  )
}

func cleanTitle(_ str: String) -> String {
  let clean = str.trimmingCharacters(in: .whitespaces)
    .replacingOccurrences(of: "\\W", with: "-", options: .regularExpression)
    .replacingOccurrences(of: "-+", with: "-", options: .regularExpression)
    .lowercased()

  return String(clean.prefix(100))
}

func getDir(_ str: String) -> String? {
  let tags = extractTags(str)
  return tags[0].components(separatedBy: "/").first
}

func extractTags(_ str: String) -> [String] {
  let regex = try! NSRegularExpression(pattern: "#[\\w\\/]+")

  let nsStr = str as NSString
  return regex.matches(in: str, options: [], range: NSRange(location: 0, length: nsStr.length)).map
  {
    String(nsStr.substring(with: $0.range).dropFirst())
  }.unique()
}

func mkdir(_ dir: URL) throws {
  if !FileManager.default.fileExists(atPath: dir.path) {
    print("creating directory \(dir.path)")
    try FileManager.default.createDirectory(
      at: dir, withIntermediateDirectories: true, attributes: nil)
  }
}

func processContent(uuid: String, contents: String) -> String {
  return "\(contents)\n\nBearID: \(uuid)\n"
}

extension Sequence where Iterator.Element: Hashable {
  func unique() -> [Iterator.Element] {
    var seen: Set<Iterator.Element> = []
    return filter { seen.insert($0).inserted }
  }
}
