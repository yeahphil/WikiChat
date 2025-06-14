# WikiChat

WikiChat is a small demonstration application that showcases Apple's new `FoundationModels` framework. It allows you to have a conversation with a Wikipedia article, asking questions and getting answers based on the article's content. Because of context limits, you're actually chatting with the text of the article preview, not the full article.

<img width="300" alt="IMG_3415" src="https://github.com/user-attachments/assets/d9d10f26-d7da-495b-bde3-3011e6e5f617" />

## How it Works

1.  **Search:** You can search for any article on Wikipedia.
2.  **Select:** Choose an article from the search results.
3.  **Chat:** The app will download a preview of the article and use it to power a local large language model (LLM). You can then ask questions about the article and get responses generated by the LLM.

## Code Structure

*   `WikiChatApp.swift`: The main entry point for the application.
*   `Views/`: This directory contains all the SwiftUI views.
    *   `ContentView.swift`: The root view of the application.
    *   `SearchView.swift`: The view for searching for Wikipedia articles.
    *   `ArticleChatView.swift`: The main chat interface where you interact with the article.
    *   `ExchangeView.swift`: A view for displaying a single chat message.
*   `Wikipedia+async.swift`: An extension on `WikipediaKit` to provide modern `async/await` APIs.
*   `Exchange.swift`: The data model for a single chat exchange (a prompt and a response).

## Getting Started

1.  Clone the repository.
2.  Open `WikiChat.xcodeproj` in Xcode.
3.  Build and run the app on a device running iOS 26. A simulator running on macOS 15 will not work -- I haven't tried Tahoe but presumably it will.
