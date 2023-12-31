//
//  FlashcardDetailView.swift
//  tudcards
//
//  Created by Leon on 14.07.23.
//

import SwiftUI

struct FlashcardDetailView: View {
    @State private var isShowingAnswer = false
    @Namespace private var cardNamespace
    var flashcard: Flashcard
    @Environment(\.presentationMode) var presentationMode
    var isLoopEnabled: Bool
    @EnvironmentObject var categoryViewModel: CategoryViewModel


    var body: some View {
        VStack {
            CardView(isShowingAnswer: $isShowingAnswer) {
                if isShowingAnswer {
                    Text(isShowingAnswer ? flashcard.answer : flashcard.question)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Text(flashcard.question)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .padding()
            .matchedGeometryEffect(id: flashcard.id, in: cardNamespace)
            .rotation3DEffect(.degrees(isShowingAnswer ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            .animation(.default)
            
            Button(action: {
                withAnimation {
                    isShowingAnswer.toggle()
                }
            }) {
                Text(isShowingAnswer ? "Show Question" : "Show Answer")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            HStack {
                Button(action: {
                    categoryViewModel.markFlashcard(flashcard, as: true)
                }) {
                    Text("Correct")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    categoryViewModel.markFlashcard(flashcard, as: false)
                }) {
                    Text("Incorrect")
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .navigationTitle("Flashcard")
        .padding()
    }
    
}

struct CardView<Content: View>: View {
    @Binding var isShowingAnswer: Bool
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 5)
            
            VStack {
                Spacer()
                
                content()
                
                Spacer()
            }
            .rotation3DEffect(.degrees(isShowingAnswer ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        }
    }
}
