//
//  ConversionConfiguration.swift
//  PlaygroundPackager
//
//  Created by Jasdev Singh on 6/29/16.
//
//

import Foundation

/**
 Represents a conversion strategy to use when generating the package
 
 - merge: Merge all playground pages and supplementary source files into one source file in the package
 - map:   Map all playground pages and supplementary source files into their own files in the package
 */
enum ConversionStrategy: String {
    case merge
    case map
}
