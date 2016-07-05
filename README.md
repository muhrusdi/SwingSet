# SwingSet

In an early attempt to migrate [Public Extension](https://github.com/Jasdev/Public-Extension) from an Xcode Playground to a SwiftPM package, I created SwingSet as a utility to do this. It can convert `.playground` files into SwiftPM-compatible packages, with options to merge or map individual source files!

_Note:_

As of 6/5/2016, the Swift Package Manager builds executables to run on OS X (or Linux). Because of this, importing `UIKit` in packages won't work, as it is an iOS framework. This implies that converted playgrounds that use `UIKit` won't work at the moment :cry:. This should be resolved soon as SwiftPM matures though! :hatched_chick:

## Requirements
- [Xcode 8 Beta](https://developer.apple.com/download/)
- [6/20/2016 Swift Trunk Development Snapshot](https://swift.org/builds/development/xcode/swift-DEVELOPMENT-SNAPSHOT-2016-06-20-a/swift-DEVELOPMENT-SNAPSHOT-2016-06-20-a-osx.pkg) (I'll periodically update this repo to work with the latest snapshots)

## Installation and Usage
- Clone this repo and run `swift build` in the root directory
- Run `.build/debug/SwingSet [playgroundPath] [packageDestination] [merge|map]` (without braces)
  - `playgroundPath`: The absolute path (escaped) to the playground file
  - `packageDestination`: The absolute path (escaped) of the destination directory for the generated package
  - `packageDestination`: Either 'merge' or 'map' without quotes
    - Merging will collapse all playground pages and source files into a single file in the generated package (de-duping imports).
    - Mapping will convert each page and supplementary source file into its own source file in the generated package.
  - To see more documentation, simply run `.build/debug/SwingSet --help`
- For easier usage, you can alias SwingSet by adding `alias swingset='/path/to/SwingSet/.build/debug/SwingSet'` to your bash file.

## Development
- Since this repository mirrors the structure of a SwiftPM package, you can easily generate an Xcode project by running  `swift package generate-xcodeproj` in the root directory.
- After opening the project file, ensure that Xcode is using the right Swift toolchain (Xcode > Toolchains).
- Lastly, you'll need to set the executable for the SwingSet scheme by going to Scheme > Edit Scheme > Select the Run section > Select the Info tab > and set the Executable to SwingSet.

![SwingSet Scheme Executable Setting](http://i.imgur.com/1ISt5Lh.png)
