import Foundation

// MARK: - Argument Parsing

let arguments = ArgumentParser.process(arguments: Process.arguments)

let playgroundDirectory = arguments.playgroundLocation
let destination = arguments.destination
let strategy = arguments.conversionStrategy

let reader = PlaygroundReader(fileManager: .default(), playgroundPath: playgroundDirectory)

guard let reader = reader else {
    fatalError(String(SwingSetError.PlaygroundReadError))
}

let playgroudName = playgroundDirectory.ns.lastPathComponent.ns.deletingPathExtension
let packageWriter = PackageWriter(packageName: playgroudName,
                                  destinationDirectory: destination,
                                  fileManager: .default())

switch strategy {
case .merge:
    do {
        guard let resultingPackageSource = reader.sourceFromPlayground() else {
            fatalError(String(SwingSetError.PlaygroundReadError))
        }
        
        try packageWriter.createPackage(playgroundSource: resultingPackageSource)
    }
    catch {
        fatalError(String(SwingSetError.DestinationWriteError))
    }
case .map:
    guard let pages = reader.sourceFilesFromPlayground() else {
        fatalError(String(SwingSetError.PlaygroundReadError))
    }
    
    do {
        try packageWriter.createPackage(files: pages)
    }
    catch {
        fatalError(String(SwingSetError.DestinationWriteError))
    }
}
