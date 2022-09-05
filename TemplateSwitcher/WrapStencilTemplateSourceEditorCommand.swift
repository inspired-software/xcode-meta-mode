//
//  ToggleSourceEditorCommand.swift
//
//  Copyright © 2022 Inspired Software, LLC
//

import Foundation
import XcodeKit

/// Convert Placeholders to Stencil Template or vice-versa
class WrapStencilTemplateSourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    // TODO: Improve this code.
    private func wrapStencilTemplate(sourceToFormat: String) throws -> String {
        var newSource = ""
        for line in sourceToFormat.components(separatedBy: "\n") {
            
            // Convert expressions
            let exprParts = line.components(separatedBy: "{%")
            var newLine = exprParts[0]
            for part in exprParts.dropFirst() {
                guard let range = part.range(of:"%}") else {
                    throw NSError(
                        domain: "WrapStencilTemplate",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Syntax error. Missing: `%}`"]
                    )
                }
                newLine.append("<#{%")
                newLine.append(part.replacingCharacters(in: range, with: "%}#>"))
            }
            
            // Convert values
            let valParts = newLine.components(separatedBy: "{{")
            var newLine2 = valParts[0]
            for part in valParts.dropFirst() {
                guard let range = part.range(of:"}}") else {
                    throw NSError(
                        domain: "WrapStencilTemplate",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Syntax error. Missing: `}}`"]
                    )
                }
                newLine2.append("<#{{")
                newLine2.append(part.replacingCharacters(in: range, with: "}}#>"))
            }
            
            // Convert comments
            let commentParts = newLine2.components(separatedBy: "{#")
            newSource.append(commentParts[0])
            for part in commentParts.dropFirst() {
                guard let range = part.range(of:"#}") else {
                    throw NSError(
                        domain: "WrapStencilTemplate",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Syntax error. Missing: `#}`"]
                    )
                }
                newSource.append("<#{#")
                newSource.append(part.replacingCharacters(in: range, with: "#}#>"))
            }
        
            newSource.append("\n")
        }
        newSource.removeLast() // Remove last '\n'
        return newSource
    }
    
    // TODO: Improve this code.
    private func unwrapStencilTemplate(sourceToFormat: String) throws -> String {
        var newSource = ""
        for line in sourceToFormat.components(separatedBy: "\n") {
            let parts = line.components(separatedBy: "<#{")
            newSource.append(parts[0])
            for part in parts.dropFirst() {
                guard let range = part.range(of:"}#>") else {
                    throw NSError(
                        domain: "UnwrapStencilTemplate",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Syntax error. Missing: `#>`"] // TODO: Show correct Stencil template closing syntax in error message.
                    )
                }
                if part.hasPrefix("%") || part.hasPrefix("{") || part.hasPrefix("#") { // Stencil expression
                    newSource.append("{")
                    newSource.append(part.replacingCharacters(in: range, with: "}"))
                } else { // Standard placeholder
                    newSource.append("<#")
                    newSource.append(part.replacingCharacters(in: range, with: "#>"))
                }
            }
            newSource.append("\n")
        }
        newSource.removeLast() // Remove last '\n'
        return newSource
    }
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        let sourceToFormat = invocation.buffer.completeBuffer
        
        let newSource: String
        do {
            // Determine what kind of format it is
            if sourceToFormat.contains("<#{") {
                // TODO: Maybe check for `<#{%`, `<#{{`, and `<#{#` to more specifically target this syntax.
                newSource = try unwrapStencilTemplate(sourceToFormat: sourceToFormat)
            } else {
                newSource = try wrapStencilTemplate(sourceToFormat: sourceToFormat)
            }
        } catch {
            completionHandler(error)
            return
        }

        // Remove all selections to avoid a crash when changing the contents of the buffer.
        invocation.buffer.selections.removeAllObjects()
        
        // Update source editor
        invocation.buffer.completeBuffer = newSource
        
        // TODO: Restore selection. Look at SwiftFormatter for an example.
                    
        completionHandler(nil) // Pass `nil` on success
    }
        
}
