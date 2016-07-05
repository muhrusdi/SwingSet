//
//  String+NSString.swift
//  PlaygroundPackager
//
//  Created by Jasdev Singh on 7/2/16.
//
//

import Foundation

/**
 *  Note: This extension is handy because it better allows for Foundation/Swift bridging without having to constantly cast
 */

extension NSString {
    
    /// Bridge to a Swift `String`
    var swift: String {
        return self as String
    }
}

extension String {
    
    /// Bridge back to an `NSString`
    var ns: NSString {
        return self as NSString
    }
}
