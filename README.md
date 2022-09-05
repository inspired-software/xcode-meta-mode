# Meta Mode Xcode Extension

Wraps and unwraps the template syntax in `*.stencil.swift` files containing Xcode placeholders. This creates an effect of switching editing contexts between writing Swift source code and Sourcery metaprogramming. Use of Xcode placeholders allows for autocompletion and syntax highlighting.

* `<#{% expression %}#>` maps to `{% expression %}`

* `<#{{value}}#>` maps to `{{value}}`

* `<#{# comment #}#>` maps to `{# comment #}`

* Other placeholders will be untouched and may be used in documentation comments or unfinished Swift code.

## Setup (macOS 13.0+)

1. Run the "Meta Mode for Xcode.app".

2. Open System Settings.

3. Search for "Extensions".

4. Under "Xcode Source Editor" select "Template Switcher".

5. Close System Settings.

6. Open Settings from the Xcode menu.

7. Select Key Bindings.

8. Search for "Wrap/Unwrap".

9. Set a key binding.

## Using With Sorcery

A preprocessor to convert back to a Sorcery compatible stencil file is included in the Utilities folder.
