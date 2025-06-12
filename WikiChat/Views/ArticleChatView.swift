//
//  ArticleChatView.swift
//  WikiChat
//
//  Created by Phillip Kast on 6/11/25.
//

import SwiftUI
import WikipediaKit
import FoundationModels

struct ArticleChatView: View {
    let preview: WikipediaArticlePreview
    @State private var rawArticle: String? = nil
    @State private var session = LanguageModelSession()
    
    @State private var prompt: String = ""
    @State private var chat: [Exchange] = []
    
    @State private var position = ScrollPosition()
    
    var isAvailable: Bool {
        SystemLanguageModel.default.isAvailable
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Section {
                    Text(preview.displayTitle)
                        .font(.title)
                    Text(preview.displayText)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                
                if rawArticle != nil {
                    if isAvailable {
                        Section {
                            ForEach(chat) { exchange in
                                ExchangeView(exchange: exchange)
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    } else {
                        Text("System language model is not available.")
                            .font(.headline)
                    }
                } else {
                    VStack {
                        Text("Loading...")
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .scrollTargetLayout()
        }
        .scrollPosition($position)
        .onChange(of: chat, { _, _ in
            position.scrollTo(edge: .bottom)
        })
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                TextField("Ask away", text: $prompt)
                    .disabled(session.isResponding)
                    .onSubmit {
                        generateResponse(prompt)
                        prompt = ""
                    }
            }
        }
        .task {
            do {
                let result = try await Wikipedia.shared
                    .rawArticle(language: .init("en"), title: preview.title)
                
                rawArticle = result
                session = LanguageModelSession(instructions: {
                    instructions()
                })
            } catch {
                print(String(describing: error))
                rawArticle = nil
            }
        }
    }
    
    func generateResponse(_ prompt: String) {
        Task {
            do {
                var exchange = Exchange(prompt: prompt, response: nil)
                chat.append(exchange)
                
                for try await resp in session.streamResponse(to: prompt) {
                    exchange.response = resp
                    if let i = chat.firstIndex(where: { $0.id == exchange.id }) {
                        chat[i] = exchange
                    }
                }
            } catch {
                chat.append(.init(prompt: prompt, response: "Error: \(error)"))
            }
        }
    }
    
    func request(_ prompt: String) -> String {
        """
        You are a helpful assistant. Answer this question as best you can using the article contents below.
        
        Question:
        ---
        \(prompt)
        
        Article:
        ---
        \(preview.displayText)
        """
    }
    
    func instructions() -> String {
        """
        You are a helpful assistant. Answer questions in the prompts as best you can using the article contents below.
        
        Article:
        ---
        \(preview.displayText)
        """
    }
}
