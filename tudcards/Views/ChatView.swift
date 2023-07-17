//
//  ChatView.swift
//  tudcards
//
//  Created by Leon on 16.07.23.
//

import Foundation
import SwiftUI

// ChatView.swift

struct ChatView: View {
    @State private var message = ""
    @State private var numFlashcards = "" 
    @State private var selectedCategory: Category?
    @ObservedObject var categoryViewModel: CategoryViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categoryViewModel.categories, id: \.id) { category in
                        Text(category.title).tag(category as Category?)
                    }
                }
                .padding()

                TextField("Number of Flashcards", text: $numFlashcards)
                    .keyboardType(.numberPad)
                    .padding()
                
                TextEditor(text: $message)
                    .frame(minHeight: 300)
                    .border(Color.gray, width: 1)
                    .padding()

                Button(action: generateFlashcards) {
                    Text("Generate Flashcards")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(message.isEmpty || selectedCategory == nil || numFlashcards.isEmpty)
            }
            .navigationTitle("Generate with GPT")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red))
            .onTapGesture {
                self.endEditing()
            }
        }
    }

    func generateFlashcards() {
        let service = OpenAIService()
        service.generateFlashcards(prompt: message, numFlashcards: Int(numFlashcards) ?? 5) { flashcards in
            DispatchQueue.main.async {
                guard let category = self.selectedCategory else { return }
                flashcards.forEach { flashcard in
                    categoryViewModel.createFlashcard(in: category, question: flashcard.question, answer: flashcard.answer)
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#if canImport(UIKit)
extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
