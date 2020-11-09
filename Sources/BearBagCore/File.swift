import Foundation

enum FileType: String {
  case image
  case file
}

public struct File: Equatable {
  let type: FileType
  let path: String
  let directory: String

  public init(type: String, path: String, directory: String) {
    self.type = FileType(rawValue: type)!
    self.path = path
    self.directory = directory
  }

  var srcFolder: String {
    switch type {
    case .image:
      return "Note Images"
    case .file:
      return "Note Files"
    }
  }

  public var bearMarkup: String {
    return "[\(type):\(path)]"
  }

  public var markdown: String {
    let relativeFolder = (directory as NSString).lastPathComponent
    switch type {
    case .image:
      return "![](\(relativeFolder)/\(filename))"
    case .file:
      return "[\(filename)](\(relativeFolder)/\(filename))"
    }
  }

  public var source: String {
    return "\(srcFolder)/\(path)"
  }

  var filename: String {
    let parts = path.split(separator: "/", maxSplits: 2)
    if parts.count != 2 {
      // this shouldn't happen but this feels like a good fallback
      return path
    }
    return String(parts[1])
  }

  public var destination: String {
    return "\(directory)/\(filename)"
  }
}
