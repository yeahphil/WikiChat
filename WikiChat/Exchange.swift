//
//  Exchange.swift
//  WikiChat
//
//  Created by Phillip Kast on 6/11/25.
//

import Foundation

struct Exchange: Identifiable, Hashable, Equatable {
    let id = UUID()
    let prompt: String
    var response: String?
}
