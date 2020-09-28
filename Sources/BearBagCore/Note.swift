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

  public var cleanTitle: String {
    let clean = title.trimmingCharacters(in: .whitespaces)
      .replacingOccurrences(of: "\\W", with: "-", options: .regularExpression)
      .replacingOccurrences(of: "-+", with: "-", options: .regularExpression)
      .lowercased()
    return String(clean.prefix(100))
  }

  public var dir: String? {
    if tags.count == 0 {
      return nil
    }
    return tags[0].components(separatedBy: "/").first
  }

  var tags: [String] {
    let regex = try! NSRegularExpression(pattern: "#[\\w\\/]+")

    let nsStr = text as NSString
    return regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsStr.length))
      .map {
        String(nsStr.substring(with: $0.range).dropFirst())
      }.unique()
  }

  public var markdown: String {
    return "\(text)\n\nBearID: \(uuid)\n"
  }

}
