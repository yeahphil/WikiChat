//
//  ContentView.swift
//  WikiChat
//
//  Created by Phillip Kast on 6/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            SearchView()
                .navigationTitle("WikiChat")
        }
    }
}

#Preview {
    ContentView()
}
