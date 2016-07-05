//
//  PlaygroundReader.swift
//  PlaygroundPackager
//
//  Created by Jasdev Singh on 7/2/16.
//
//

import Foundation

/// Alias to represent a playground source file
typealias PlaygroundSourceFile = (fileName: String, contents: String)

/**
 *  Helper struct to use when reading playground files from disk
 */
struct PlaygroundReader {
    private let fileManager: FileManager
    private let playgroundPath: String
    private let enumerator: FileManager.DirectoryEnumerator
    
    private enum Constants {
        enum PathExtensions {
            static let swift = "swift"
            static let playgroundPage = "xcplaygroundpage"
            static let playground = "playground"
        }
    }
    
    private var swiftFilePaths: [NSString]? {
        return (enumerator.allObjects as? [NSString])?
            .filter { $0.pathExtension == Constants.PathExtensions.swift }
    }
    
    /**
     Failable initializer used to construct a reader
     
     - parameter fileManager:    The file manager to use
     - parameter playgroundPath: The path to the playground
     
     - returns: A `PlaygroundReader` instance or `nil`, if an enumerator at `playgroundPath` can't be initialized.
     */
    init?(fileManager: FileManager, playgroundPath: String) {
        self.fileManager = fileManager
        self.playgroundPath = playgroundPath
        
        guard let enumerator = fileManager.enumerator(atPath: playgroundPath) else { return nil }
        self.enumerator = enumerator
    }

    /**
     Fetches the merged source from a playground file
     
     - returns: The playground source or `nil`, if there is a reading error.
     */
    func sourceFromPlayground() -> String? {
        return swiftFilePaths?.flatMap {
                guard
                    let path = (playgroundPath + ($0.swift)).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
                else { return nil }
                
                return try? String(contentsOfFile: path, encoding: .utf8)
            }
            .joined(separator: "\n")
    }
    
    /**
     Fetches the source from a playground file without merging
     
     - returns: The playground source files or `nil`, if there is a reading error.
     */
    func sourceFilesFromPlayground() -> [PlaygroundSourceFile]? {
        return swiftFilePaths?.flatMap {
                guard
                    let path = (playgroundPath + ($0.swift)).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
                else { return nil }
                
                if let contents = try? String(contentsOfFile: path, encoding: .utf8) {
                    let fileName: String
                    
                    // If we're currently on the default `Contents.swift` file of each page (or a new playground), use the page (playground) name
                    if Set([Constants.PathExtensions.playgroundPage, Constants.PathExtensions.playground])
                        .contains(path.ns.deletingLastPathComponent.ns.pathExtension) {
                        
                        // I'm so sorry Foundation Gods.
                        fileName = path.ns.deletingLastPathComponent.ns.lastPathComponent.ns.deletingPathExtension
                    }
                    else {
                        fileName = path.ns.lastPathComponent.ns.deletingPathExtension
                    }
                    
                    return (fileName: fileName, contents: contents)
                }
                else {
                    return nil
                }
            }
    }
}
