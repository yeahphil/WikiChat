//
//  ExchangeView.swift
//  WikiChat
//
//  Created by Phillip Kast on 6/11/25.
//

import SwiftUI

struct ExchangeView: View {
    let exchange: Exchange
    var body: some View {
        HStack {
            Spacer()
            Text(exchange.prompt)
                .padding()
                .background(.gray.tertiary, in: RoundedRectangle(cornerRadius: 24))
        }
        
        HStack {
            if let response = exchange.response {
                Text(LocalizedStringKey(response))
                    .padding()
                    .background(.blue.tertiary, in: RoundedRectangle(cornerRadius: 24))
            } else {
                ProgressView()
            }
            
            Spacer()
        }
    }
}

#Preview {
    ExchangeView(
        exchange: .init(
            prompt: "Why is the sky blue?",
            response: "Probably because of something *you* did."
        )
    )
}
