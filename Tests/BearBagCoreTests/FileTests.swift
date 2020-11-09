import XCTest

@testable import BearBagCore

final class fileTests: XCTestCase {
  let file = File(
    type: "file",
    path: "7EA751E0-D1DB-4128-A02F-F773FEC0DBF8-85992-000165FFFD3D2095/foo.pdf",
    directory: "path/to/out"
  )

  let image = File(
    type: "image",
    path:
      "7EA751E0-D1DB-4128-A02F-F773FEC0DBF8-85992-000165FFFD3D2095/389EE865-B870-46CC-AF3D-38708AE4CCDB.png",
    directory: "path/to/out"
  )

  func testBearMarkup() {
    XCTAssertEqual(
      image.bearMarkup,
      "[image:7EA751E0-D1DB-4128-A02F-F773FEC0DBF8-85992-000165FFFD3D2095/389EE865-B870-46CC-AF3D-38708AE4CCDB.png]"
    )
    XCTAssertEqual(
      file.bearMarkup, "[file:7EA751E0-D1DB-4128-A02F-F773FEC0DBF8-85992-000165FFFD3D2095/foo.pdf]")
  }

  func testMarkdown() {
    XCTAssertEqual(image.markdown, "![](out/389EE865-B870-46CC-AF3D-38708AE4CCDB.png)")
    XCTAssertEqual(file.markdown, "[foo.pdf](out/foo.pdf)")
  }

  func testSource() {
    XCTAssertEqual(
      image.source,
      "Note Images/7EA751E0-D1DB-4128-A02F-F773FEC0DBF8-85992-000165FFFD3D2095/389EE865-B870-46CC-AF3D-38708AE4CCDB.png"
    )
    XCTAssertEqual(
      file.source, "Note Files/7EA751E0-D1DB-4128-A02F-F773FEC0DBF8-85992-000165FFFD3D2095/foo.pdf")
  }

  func testDestination() {
    XCTAssertEqual(image.destination, "path/to/out/389EE865-B870-46CC-AF3D-38708AE4CCDB.png")
    XCTAssertEqual(file.destination, "path/to/out/foo.pdf")

    let weird = File(
      type: "image",
      path: "foo.png",
      directory: "path/to/out"
    )

    XCTAssertEqual(weird.destination, "path/to/out/foo.png")
  }

}
