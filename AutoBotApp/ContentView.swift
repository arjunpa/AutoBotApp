//
//  ContentView.swift
//  AutoBotApp
//
//  Created by Arjun P A on 15/01/26.
//

import SwiftUI

struct ContentView: View {

    @State private var showNext = false
    @State private var honeypotText = ""
    @FocusState private var honeypotFocused: Bool

    var body: some View {
        VStack(spacing: 24) {

            Button("Take Survey") {
                showNext = true
            }
            .accessibilityIdentifier("primaryCTA")

            if showNext {
                Button("Next") { }
                    .accessibilityIdentifier("next")
            }

            // ✅ Honeypot that bots can fill, but keyboard never opens
            // Honeypot
            TextField("nnb", text: $honeypotText)
                .frame(width: 1, height: 25)
                .accessibilityIdentifier("answer")
                .focused($honeypotFocused)

            Spacer()
        }
        .padding()
    }
}
