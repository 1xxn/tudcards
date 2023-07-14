//
//  OverlayView.swift
//  tudcards
//
//  Created by Leon on 14.07.23.
//

import SwiftUI

struct OverlayView: View {
    @State private var translation: CGSize = .zero
    @State private var showSwipeMessage: Bool = false

    var body: some View {
        VStack {
            if showSwipeMessage {
                Text("Swipe left or right to navigate")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .transition(.opacity)
            }

            Spacer()
        }
        .offset(x: translation.width, y: 0)
        .gesture(
            DragGesture()
                .onChanged { value in
                    translation = value.translation
                    showSwipeMessage = true
                }
                .onEnded { value in
                    let horizontalSwipeGesture = value.predictedEndTranslation.width > 100
                    let verticalSwipeGesture = abs(value.predictedEndTranslation.height) < 50

                    if horizontalSwipeGesture && verticalSwipeGesture {
                        // perform navigation logic here based on the swipe direction
                        // For example, navigate to the next flashcard or dismiss the view
                    }

                    translation = .zero
                    showSwipeMessage = false
                }
        )
        .animation(.spring())
        .onAppear {
            showSwipeMessage = true
        }
    }
}

