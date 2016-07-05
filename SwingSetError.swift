//
//  SwingSetError.swift
//  PlaygroundPackager
//
//  Created by Jasdev Singh on 7/2/16.
//
//

import Foundation

/**
 Represents an error that SwingSet can encounter
 
 - PlaygroundReadError:   An error in reading the target playground file
 - DestinationWriteError: An error in writing the generated package to the target destination directory
 - InvalidArguments:      An error representing invalid arguments being passed into SwingSet
 */
enum SwingSetError: ErrorProtocol {
    case PlaygroundReadError
    case DestinationWriteError
    case InvalidArguments
}

// MARK: - CustomStringConvertible

extension SwingSetError: CustomStringConvertible {
    var description: String {
        switch self {
        case .PlaygroundReadError:
            return "Failed to read the .playground file. Make sure it exists and the script has read access to it!"
        case DestinationWriteError:
            return "Failed to write to the destination path!"
        case InvalidArguments:
            return "Invalid arguments! Use --help to see available SwingSet usage/options"
        }
    }
}
