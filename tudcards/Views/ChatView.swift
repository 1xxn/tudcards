//
//  ChatView.swift
//  tudcards
//
//  Created by Leon on 16.07.23.
//

import Foundation
import SwiftUI

struct ChatView: View {
    @State private var message = ""
    @State private var numFlashcards = ""
    @State private var selectedCategory: Category?
    @State private var isLoading = false
    @State private var messages: [String] = []
    @State private var showingPicker = false
    @ObservedObject var categoryViewModel: CategoryViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    showingPicker = true
                }) {
                    HStack {
                        Text(selectedCategory?.title ?? "Category")
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .actionSheet(isPresented: $showingPicker) {
                    ActionSheet(title: Text("Select a Category"), buttons: categoryViewModel.categories.map { category in
                        .default(Text(category.title)) {
                            selectedCategory = category
                        }
                    })
                }

                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(messages, id: \.self) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                }
                
                MessageInputView(message: $message, numFlashcards: $numFlashcards, isLoading: $isLoading, action: generateFlashcards)
                    .padding()
            }
            .navigationBarTitle("Generate with GPT", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.red)
            })
            .onTapGesture {
                self.endEditing()
            }
        }
    }

    func generateFlashcards() {
        isLoading = true
        let currentMessage = message
        messages.append(currentMessage)
        message = ""
        let service = OpenAIService()
        service.generateFlashcards(prompt: currentMessage, numFlashcards: Int(numFlashcards) ?? 5) { flashcards in
            DispatchQueue.main.async {
                guard let category = self.selectedCategory else { return }
                flashcards.forEach { flashcard in
                    categoryViewModel.createFlashcard(in: category, question: flashcard.question, answer: flashcard.answer)
                }
                isLoading = false
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ChatBubble: View {
    var message: String

    var body: some View {
        HStack {
            Text(message)
                .padding(10)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(ChatBubbleShape())
        }
    }
}

struct ChatBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
        return Path(path.cgPath)
    }
}

struct MessageInputView: View {
    @Binding var message: String
    @Binding var numFlashcards: String
    @Binding var isLoading: Bool
    var action: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6)) // Light gray background
                TextEditor(text: $message)
                    .padding(10)
            }
            .frame(height: 100) // Increased height for better visibility

            VStack {
                Text("Flashcards")
                    .font(.caption)
                TextField("", text: $numFlashcards)
                    .keyboardType(.numberPad)
                    .frame(width: 30, height: 30)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
            }
            .padding(.leading)

            if isLoading {
                ActivityView()
            } else {
                Button(action: action) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
    }
}

struct ActivityView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) { }
}

#if canImport(UIKit)
extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
