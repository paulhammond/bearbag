import XCTest

@testable import BearBagCore

final class bearbagTests: XCTestCase {

  func testPath() {
    let tests: [(title: String, text: String, expected: String)] = [
      ("note", "", "note.md"),
      ("title spaces", "and #tag #a #b", "tag/title-spaces.md"),
      ("subdir", "#tag/subtag #a #b", "tag/subdir.md"),
    ]
    for test in tests {
      let note = Note(
        uuid: "zzzz",
        title: test.title,
        text: "# \(test.title)\n\(test.text)"
      )
      XCTAssertEqual(note.path, test.expected)
    }

  }

  func testCleanTitle() {
    let tests: [(title: String, expected: String)] = [
      ("note", "note"),
      ("NotE", "note"),
      ("Iñtërnâtiônàlizætiøn", "iñtërnâtiônàlizætiøn"),
      ("IÑTËRNÂTIÔNÀLIZÆTIØN", "iñtërnâtiônàlizætiøn"),
      ("note with spaces", "note-with-spaces"),
      ("a!b?c*d e_f•g", "a-b-c-d-e_f-g"),
      ("a    !!   b", "a-b"),
      (String(repeating: "ab", count: 52), String(repeating: "ab", count: 50)),
    ]
    for test in tests {
      let note = Note(
        uuid: "zzzz",
        title: test.title,
        text: "# \(test.title)\ntext"
      )
      XCTAssertEqual(note.cleanTitle, test.expected)
    }
  }

  func testTags() {
    let tests: [(text: String, expected: [String])] = [
      ("#a #b", ["a", "b"]),
      ("#a/b #b", ["a/b", "b"]),
      ("hello #b", ["b"]),
      ("hello", []),
      ("hello#a #b\n#c", ["b", "c"]),  // tags have to be preceded by whitespace
      ("#1 #12 #a1 #1a", ["a1"]),  // numbers are not tags
      ("#/ #/a #a/a", ["a/a"]),  // #/ is not a tag
    ]
    for test in tests {
      let note = Note(
        uuid: "zzzz",
        title: "title",
        text: "# title \(test.text)\n"
      )
      XCTAssertEqual(note.tags, test.expected)
    }
  }

  func testDir() {
    let tests: [(text: String, expected: String?)] = [
      ("#a #b", "a"),
      ("#a/b hello", "a"),
      ("hello", nil),
    ]
    for test in tests {
      let note = Note(
        uuid: "zzzz",
        title: "title",
        text: "# title \(test.text)\n"
      )
      XCTAssertEqual(note.dir, test.expected)
    }
  }

  func testMarkdown() {
    let note = Note(
      uuid: "zzzz",
      title: "title",
      text: "# title text"
    )
    XCTAssertEqual(note.markdown, "# title text\n\nBearID: zzzz\n")
  }

}
