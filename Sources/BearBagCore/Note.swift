import Foundation

public struct Note {
  let uuid: String
  let title: String
  let text: String

  public init(uuid: String, title: String, text: String) {
    self.uuid = uuid
    self.title = title
    self.text = text
  }

  public var path: String {
    return "\(basename).md"
  }

  var basename: String {
    if dir != nil {
      return "\(dir!)/\(cleanTitle)"
    }
    return cleanTitle
  }

  var cleanTitle: String {
    let clean = title.trimmingCharacters(in: .whitespaces)
      .replacingOccurrences(of: "\\W", with: "-", options: .regularExpression)
      .replacingOccurrences(of: "-+", with: "-", options: .regularExpression)
      .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
      .lowercased()
    return String(clean.prefix(100))
  }

  var dir: String? {
    if tags.count == 0 {
      return nil
    }
    return tags[0]
  }

  public var files: [File] {
    let regex = try! NSRegularExpression(pattern: "\\[(file|image):(.+?)\\]")
    let nsStr = text as NSString

    let matches = regex.matches(
      in: text, options: [], range: NSRange(location: 0, length: nsStr.length))
    var files = [File]()

    for m in matches {
      let fileType = String(nsStr.substring(with: m.range(at: 1)))
      let path = String(nsStr.substring(with: m.range(at: 2)))
      files += [File(type: fileType, path: path, directory: basename)]
    }
    return files
  }

  var tags: [String] {
    let regex = try! NSRegularExpression(pattern: "\\s#[\\p{Ll}\\p{Lu}\\p{Lt}\\p{Lo}][\\w\\/]*")

    let nsStr = text as NSString
    return regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsStr.length))
      .map {
        String(nsStr.substring(with: $0.range).dropFirst(2))
      }.unique()
  }

  public var markdown: String {
    var md = text
    for file in files {
      md = md.replacingOccurrences(of: file.bearMarkup, with: file.markdown)
    }
    md = md.replacingOccurrences(of: "[\\t\\f\\p{Z}]+\\n", with: "\n", options: .regularExpression)
    md = md.replacingOccurrences(of: "[\\t\\f\\p{Z}]+$", with: "", options: .regularExpression)
    return "\(md)\n\nBearID: \(uuid)\n"
  }

}
