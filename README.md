# Meta Mode for Xcode

Meta Mode is an Xcode Source Editor Extension that wraps and unwraps [Sourcery][sourcery] Stencil templates with Swift placeholders. This allows the Xcode source editor to switch between writing Swift source code and Sourcery metaprogramming by pressing Control-Option-Command-M without affecting Swift autocompletion and syntax highlighting.

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

9. Set the key binding by clicking on the field then pressing Control-Option-Command-M (or another key combination of your choosing).

## Using With Sourcery

A preprocessor to convert back to a [Sourcery][sourcery] compatible Stencil file is included in the Utilities folder. Files an `*.stencil.swift` extension are processed and written to the output folder with a `*.stencil` extension. The source and output folders may be the same. Make sure the `*.stencil.swift` files are excluded from your build.

```
./Utilities/StencilPreprocessor.swift <source folder> <output folder>
```

[sourcery]: https://github.com/krzysztofzablocki/Sourcery
