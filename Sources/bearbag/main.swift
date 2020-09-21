import Foundation
import SQLite

let home = NSHomeDirectory()
let db = try Connection(
  "\(home)/Library/Group Containers/9K33E3U3T4.net.shinyfrog.bear/Application Data/database.sqlite",
  readonly: true)

let notes = Table("ZSFNOTE")

let count = try db.scalar(notes.count)

print("db has \(count) notes")
