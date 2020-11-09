import XCTest

@testable import BearBagCore

final class noteTests: XCTestCase {

  func testPath() {
    let tests: [(title: String, text: String, expected: String)] = [
      ("note", "", "note.md"),
      ("title spaces", "and #tag #a #b", "tag/title-spaces.md"),
      ("subdir", "#tag/subtag #a #b", "tag/subtag/subdir.md"),
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
      (" a b ", "a-b"),
      ("!a b!", "a-b"),
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
      ("#a/b hello", "a/b"),
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

  func testFiles() {
    let tests: [(text: String, expected: [File])] = [
      ("foo", []),
      (
        """
        foo
        [image:7EA751E0-D1DB-4128-A02F-F773FEC0DBF8-85992-000165FFFD3D2095/389EE865-B870-46CC-AF3D-38708AE4CCDB.png]
        [file:C7F1AD00-860E-4BEE-9CED-F1F90E09C09B-28765-0002B5A12E6DC5CF/myfile.pdf]
        """,
        [
          File(
            type: "image",
            path:
              "7EA751E0-D1DB-4128-A02F-F773FEC0DBF8-85992-000165FFFD3D2095/389EE865-B870-46CC-AF3D-38708AE4CCDB.png",
            directory: "hello"
          ),
          File(
            type: "file",
            path: "C7F1AD00-860E-4BEE-9CED-F1F90E09C09B-28765-0002B5A12E6DC5CF/myfile.pdf",
            directory: "hello"
          ),
        ]
      ),
      (
        "foo [image:foo.png]",
        [
          File(
            type: "image",
            path: "foo.png",
            directory: "hello"
          )
        ]
      ),
    ]
    for test in tests {
      let note = Note(
        uuid: "7EA751E0-D1DB-4128-A02F-F773FEC0DBF8-85992-000165FFFD3D2095",
        title: "hello",
        text: "# hello \(test.text)\n"
      )
      XCTAssertEqual(note.files, test.expected)
    }
  }

  func testMarkdown() {
    let note = Note(
      uuid: "zzzz",
      title: "title",
      text: "# title text\ntext   \ntab\t\n[image:7EA751E0/foo.png]\n[file:C7F1AD00/bar.pdf]\n"
    )
    XCTAssertEqual(
      note.markdown,
      "# title text\ntext\ntab\n![](title/foo.png)\n[bar.pdf](title/bar.pdf)\n\n\nBearID: zzzz\n")
  }

}
