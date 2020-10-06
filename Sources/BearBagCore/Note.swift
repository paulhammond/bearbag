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

  public var images: [String: String] {
    let regex = try! NSRegularExpression(pattern: "\\[image:(.+?)\\]")
    let nsStr = text as NSString

    let matches = regex.matches(
      in: text, options: [], range: NSRange(location: 0, length: nsStr.length))
    var dict = [String: String]()
    for m in matches {
      let orig = String(nsStr.substring(with: m.range(at: 1)))
      let parts = orig.split(separator: "/", maxSplits: 2)
      if parts.count == 2 {
        dict[orig] = "\(basename)/\(parts[1])"
      } else {
        // this shouldn't happen but this feels like a good fallback
        dict[orig] = "\(basename)/\(orig)"
      }
    }
    return dict
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
    for (orig, clean) in images {
      md = md.replacingOccurrences(of: "[image:\(orig)]", with: "![](\(clean))")
    }
    return "\(md)\n\nBearID: \(uuid)\n"
  }

}
