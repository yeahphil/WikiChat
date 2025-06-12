//
//  Wikipedia+async.swift
//  WikiChat
//
//  Created by Phillip Kast on 6/11/25.
//

import Foundation
import WikipediaKit
import Playgrounds

extension WikipediaArticlePreview: @retroactive Identifiable {
    public var id: String {
        url?.absoluteString ?? title
    }
}

extension Wikipedia {
    func requestOptimizedSearchResults(language: WikipediaLanguage,
                                       term: String,
                                       existingSearchResults: WikipediaSearchResults? = nil,
                                       imageWidth: Int = 200,
                                       minCount: Int = 10,
                                       maxCount: Int = 15
    ) async throws -> WikipediaSearchResults {
        try await withCheckedThrowingContinuation { c in
            _ = requestOptimizedSearchResults(language: language, term: term, existingSearchResults: existingSearchResults, imageWidth: imageWidth, minCount: minCount, maxCount: maxCount) { results, error in
                if let error {
                    c.resume(throwing: error)
                    return
                } else if let results {
                    c.resume(returning: results)
                } else {
                    c.resume(throwing: WikipediaError.other("Nil results"))
                }
            }
        }
    }
    
    func requestArticle(language: WikipediaLanguage,
                        title: String,
                        fragment: String? = nil,
                        imageWidth: Int,
    ) async throws -> WikipediaArticle {
        try await withCheckedThrowingContinuation { c in
            _ = requestArticle(language: language, title: title, imageWidth: imageWidth) { result in
                switch result {
                case .success(let article):
                    c.resume(returning: article)
                case .failure(let failure):
                    c.resume(throwing: failure)
                }
            }
        }
    }
    
    func rawArticle(language: WikipediaLanguage, title: String) async throws -> String {
        guard let url = URL(string: "https://\(language.code).wikipedia.org/w/index.php?title=\(title)&action=raw") else {
            throw WikipediaError.other("bad URL")
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        return String(data: data, encoding: .utf8)!
    }
}

#Playground {
    let results = try await Wikipedia.shared
        .requestOptimizedSearchResults(language: .init("en"), term: "walruses")
}

#Playground {
    do {
        let results = try await Wikipedia.shared
            .requestArticle(language: .init("en"), title: "Soft rime", imageWidth: 640)
    } catch {
        error
    }
}
