//
//  ContentView.swift
//
//  Copyright © 2022 Inspired Software, LLC
//

import SwiftUI

//let userDefaults = UserDefaults(suiteName: (Bundle.main.object(forInfoDictionaryKey: "TeamIdentifierPrefix") as! String) + "metaprogramming-mode")

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Open System Settings to enable the Xcode Template Switcher extension.")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
