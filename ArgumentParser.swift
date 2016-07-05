//
//  ArgumentParser.swift
//  PlaygroundPackager
//
//  Created by Jasdev Singh on 7/4/16.
//
//

import Foundation

/// Alias to represent arguments that SwingSet accepts
typealias SwingSetArguments = (playgroundLocation: String, destination: String, conversionStrategy: ConversionStrategy)

/**
 *  Helper struct to parse comman-line arguments passed into SwingSet
 */
struct ArgumentParser {
    private enum Constants {
        static let argumentCount = 3
        static let helpFlag = "--help"
    }
    
    // Prevent initialization
    private init() {}
    
    /**
     Processes raw command-line arguments from the process
     
     - parameter arguments: The arguments to process
     
     - returns: Typed (and labeled) arguments that SwingSet can work with in generating the package
     */
    static func process(arguments: [String]) -> SwingSetArguments {
        var arguments = Array(arguments.dropFirst())
        
        guard !arguments.contains(Constants.helpFlag) else {
            print(ArgumentParser.helpMessage)
            exit(EXIT_SUCCESS)
        }
        
        guard arguments.count == Constants.argumentCount else {
            fatalError(String(SwingSetError.InvalidArguments))
        }
        
        guard let strategy = ConversionStrategy(rawValue: arguments[2]) else {
            fatalError(String(SwingSetError.InvalidArguments))
        }
        
        return (playgroundLocation: arguments[0].directoryPathSuffixed,
                destination: arguments[1].directoryPathSuffixed,
                conversionStrategy: strategy)
    }
    
    private static let helpMessage: String = "SwingSet takes commands in the following form:\n\n" +
        "path/to/SwingSet/.build/debug/SwingSet [playgroundPath] [packageDestination] [merge|map]\n\n" +
        "Arguments:\n====================\n" +
        "playgroundPath: The absolute path (escaped) to the playground file\n" +
        "packageDestination: The absolute path (escaped) of the destination directory for the generated package\n" +
        "packageDestination: Either 'merge' or 'map' without quotes\n\t" +
            "Merging will collapse all playground pages and source files into a single file in the generated package.\n\t" +
            "Mapping will convert each page and supplementary source file into its own source file in the generated package."
}
