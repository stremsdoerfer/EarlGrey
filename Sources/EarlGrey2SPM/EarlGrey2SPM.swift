import Foundation

public struct EarlGrey2SPM {
    public private(set) var text = "Hello, World!"

    public init() {
      let fileManager = FileManager.default
      let path = fileManager.currentDirectoryPath
      print("hey")
    }
}
