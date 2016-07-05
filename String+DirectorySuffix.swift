//
//  String+DirectorySuffix.swift
//  PlaygroundPackager
//
//  Created by Jasdev Singh on 7/4/16.
//
//

import Foundation

extension String {
    
    /// Returns a version of `self` with a trailing slash to ensure consitency when handling directory paths
    var directoryPathSuffixed: String {
        if !hasSuffix("/") {
            return self + "/"
        }
        
        return self
    }
}
