#!/usr/bin/swift
//
//  StencilPreprocessor.swift
//  A simple utility to convert Xcode placeholders to Stencil formatted templates.
//
//  The author disclaims copyright to this source file. In place of a legal notice,
//  here is a blessing:
//
//    *   May you do good and not evil.
//    *   May you find forgiveness for yourself and forgive others.
//    *   May you share freely, never taking more than you give.
//

import Foundation

if CommandLine.arguments.count != 3 {
    print("Usage: ./\(CommandLine.arguments[0]) <source folder> <output folder>")
    exit(1)
}
let sourceFolder = CommandLine.arguments[1]
let outputFolder = CommandLine.arguments[2]

func directoryExists(atPath path: String) -> Bool {
    var isDirectory = ObjCBool(true)
    let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
}

do {
    let fm = FileManager.default
    guard directoryExists(atPath: sourceFolder) else {
        print("Source folder doesn't exist.")
        exit(1)
    }
    if !directoryExists(atPath: outputFolder) {
        try fm.createDirectory(atPath: outputFolder, withIntermediateDirectories: true)
    }
    
    let sourceFiles = try fm.contentsOfDirectory(atPath: sourceFolder)
        .filter { $0.hasSuffix(".stencil.swift") }
    
    print("Processing source files:")
    for file in sourceFiles {
        print("  " + file)
        var newTemplateSource = ""
        let templateSource = try String(contentsOfFile: sourceFolder + "/" + file, encoding: .utf8)
        for line in templateSource.components(separatedBy: "\n") {
            let parts = line.components(separatedBy: "<#")
            newTemplateSource.append(parts[0])
            for part in parts.dropFirst() {
                guard let range = part.range(of:"#>") else {
                    print("Syntax error. Missing: `#>`")
                    exit(1)
                }
                if part.hasPrefix("%") || part.hasPrefix("{") || part.hasPrefix("#") { // Stencil expression
                    newSource.append("{")
                    newSource.append(part.replacingCharacters(in: range, with: "}"))
                } else { // Standard placeholder
                    newSource.append("<#")
                    newSource.append(part.replacingCharacters(in: range, with: "#>"))
                }
            }
            newTemplateSource.append("\n")
        }
        newSource.removeLast() // Remove last '\n'
        try newTemplateSource.write(to: URL(fileURLWithPath: outputFolder + "/" + file.dropLast(".swift".count)), atomically: true, encoding: String.Encoding.utf8)
    }
} catch {
    print(error)
}
