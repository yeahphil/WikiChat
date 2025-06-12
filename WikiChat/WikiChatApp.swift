//
//  WikiChatApp.swift
//  WikiChat
//
//  Created by Phillip Kast on 6/11/25.
//

import SwiftUI
import WikipediaKit

@main
struct WikiChatApp: App {
    
    init() {
        WikipediaNetworking.appAuthorEmailForAPI = "your@email.here"
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
