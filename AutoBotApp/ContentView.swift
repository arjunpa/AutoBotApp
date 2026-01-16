//
//  ContentView.swift
//  AutoBotApp
//
//  Created by Arjun P A on 15/01/26.
//

import SwiftUI

import SwiftUI

struct ContentView: View {

    @State private var showNext = false
    @State private var honeypotText = ""

    var body: some View {
        VStack(spacing: 24) {

            // STEP 0 — Take Survey
            Button("Take Survey") {
                showNext = true
            }
            .accessibilityIdentifier("primaryCTA")

            // STEP 1 — Next
            if showNext {
                Button("Next") {
                    // no-op, just advances flow
                }
                .accessibilityIdentifier("next")
            }

            // STEP 2–5 — Honeypot (hidden, clickable, no keyboard)
            TextField("", text: $honeypotText)
                .frame(width: 1, height: 1)
                .opacity(0.01)
                .accessibilityIdentifier("answer")
                .accessibilityHidden(true)
                .disabled(true)   // prevents keyboard from opening

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
