//
//  SearchView.swift
//  WikiChat
//
//  Created by Phillip Kast on 6/11/25.
//




import SwiftUI
import WikipediaKit

struct SearchView: View {
    @State private var query = ""
    @State private var isLoading = false
    @State private var results: [WikipediaArticlePreview] = []
    
    @State private var searchTask: Task<Void, Never>? = nil
    
    var body: some View {
        List {
            ForEach(results) { result in
                NavigationLink(result.displayTitle, value: result)
            }
        }
        .navigationDestination(for: WikipediaArticlePreview.self) { articlePreview in
            ArticleChatView(preview: articlePreview)
        }
        .searchable(text: $query, placement: .toolbar, prompt: "Search Wikipedia")
        .onChange(of: query) { _, newValue in
            searchTask?.cancel()
            Task {
                guard !newValue.isEmpty else {
                    results = []
                    return
                }

                // Debounce a bit:
                try await Task.sleep(for: .milliseconds(300))
                try Task.checkCancellation()
                
                results = try await Wikipedia.shared
                    .requestOptimizedSearchResults(language: .init("en"), term: newValue)
                    .items
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
