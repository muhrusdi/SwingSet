//
//  PackageWriter.swift
//  PlaygroundPackager
//
//  Created by Jasdev Singh on 7/2/16.
//
//

import Foundation

/**
 *  Helper struct to use when writing the generated package to disk
 */
struct PackageWriter {
    private let packageName: String
    private let destinationDirectory: String
    private let fileManager: FileManager
    
    private var packageRoot: String {
        return destinationDirectory.ns.appendingPathComponent(packageName)
    }
    
    private var packageSourceDirectory: String {
        return packageRoot.ns.appendingPathComponent("Sources")
    }
    
    private var packageManifestFileContents: NSString {
        return "import PackageDescription\n\n" +
               "let package = Package(name: \"\(packageName)\")"
    }
    
    private enum Constants {
        enum PathExtensions {
            static let swift = "swift"
        }
        
        static let manifestFileName = "Package"
    }
    
    /**
     Initializes a `PackageWriter` to use in the generation process
     
     - parameter packageName:          The package name to use
     - parameter destinationDirectory: The destination directory to write the package to
     - parameter fileManager:          The file manager to use when writing to disk
     
     - returns: An instance of `PackageWriter`
     */
    init(packageName: String, destinationDirectory: String, fileManager: FileManager) {
        self.packageName = packageName
        self.destinationDirectory = destinationDirectory
        self.fileManager = fileManager
    }
    
    /**
     Creates a package from merged playground source code
     
     - parameter playgroundSource: The source code to use from the playground
     
     - throws: Any errors from attempting to write the package to disk
     */
    func createPackage(playgroundSource: String) throws {
        try setupPackageDirectoryStructure()
        
        let mergedSource = mergeAndRearrangeImports(playgroundSource: playgroundSource)
        
        try mergedSource.write(toFile: packageSourceDirectory.ns.appendingPathComponent("\(packageName).\(Constants.PathExtensions.swift)"),
                           atomically: true,
                           encoding: .utf8)
    }
    
    /**
     Creates a package from an array of individual source files
     
     - parameter files: The playground (and supplementary) source files
     
     - throws: Any errors from attempting to write the package to disk
     */
    func createPackage(files: [PlaygroundSourceFile]) throws {
        try setupPackageDirectoryStructure()
        
        try files.forEach {
            try $0.contents.write(toFile: packageSourceDirectory.ns.appendingPathComponent("\($0.fileName).\(Constants.PathExtensions.swift)"),
                                   atomically: true,
                                   encoding: .utf8)
        }
    }
    
    private func setupPackageDirectoryStructure() throws {
        try fileManager.createDirectory(atPath: packageRoot.swift,
                                        withIntermediateDirectories: true,
                                        attributes: nil)
        
        try fileManager.createDirectory(atPath: packageSourceDirectory.swift,
                                        withIntermediateDirectories: true,
                                        attributes: nil)
        
        try packageManifestFileContents.swift.write(toFile: packageRoot.ns.appendingPathComponent("\(Constants.manifestFileName).\(Constants.PathExtensions.swift)").swift,
                                                    atomically: true,
                                                    encoding: .utf8)
    }
    
    private func mergeAndRearrangeImports(playgroundSource: String) -> String {
        var imports = Set<String>()
        var nonImportLines = Array<String>()
        
        playgroundSource.enumerateLines { line, _ in
            if line.trimmingCharacters(in: .whitespaces).hasPrefix("import") {
                imports.insert(line)
            }
            else {
                nonImportLines.append(line)
            }
        }
        
        let mergedContents = Array(imports) + ["\n"] + nonImportLines
        return mergedContents.joined(separator: "\n")
    }
}
