//
//  ChatView.swift
//  tudcards
//
//  Created by Leon on 16.07.23.
//

import Foundation
import SwiftUI
import PDFKit
import MobileCoreServices


struct ChatView: View {
    @State private var message = ""
    @State private var pdfText = ""
    @State private var numFlashcards = ""
    @State private var selectedCategory: Category?
    @State private var isLoading = false
    @State private var messages: [String] = []
    @State private var showingPicker = false
    @ObservedObject var categoryViewModel: CategoryViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var isDocumentPickerShown = false

    var body: some View {
            NavigationView {
                VStack {
                    HStack {
                        Button(action: {
                            showingPicker = true
                        }) {
                            HStack {
                                Text(selectedCategory?.title ?? "Category")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        .actionSheet(isPresented: $showingPicker) {
                            ActionSheet(title: Text("Select a Category"), buttons: categoryViewModel.categories.map { category in
                                .default(Text(category.title)) {
                                    selectedCategory = category
                                }
                            } + [.cancel()])
                        }
                        .padding([.leading, .trailing])

                        Button(action: {
                            isDocumentPickerShown = true
                        }) {
                            Text("Upload PDF")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented: $isDocumentPickerShown) {
                            DocumentPicker { url in
                                let pdfDocument = PDFDocument(url: url)
                                pdfText = pdfDocument?.string ?? ""
                                message = pdfText
                                generateFlashcards()
                            }
                        }
                        .padding([.leading, .trailing])
                    }

                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(messages, id: \.self) { message in
                            ChatBubble(message: message)
                                .transition(.move(edge: .trailing))
                                .animation(.spring())
                        }
                    }
                    .padding()
                }

                    MessageInputView(message: $message, numFlashcards: $numFlashcards, isLoading: $isLoading, isSendButtonDisabled: selectedCategory == nil || message.isEmpty, action: generateFlashcards)
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
    @Environment(\.colorScheme) var colorScheme
    @Binding var message: String
    @Binding var numFlashcards: String
    @Binding var isLoading: Bool
    var isSendButtonDisabled: Bool
    var action: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            TextField("Message", text: $message)
                .padding(10)
                .foregroundColor(.primary)
                .background(colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray6))
                .cornerRadius(10)
                .frame(minHeight: 100)

            TextField("Flashcards", text: $numFlashcards)
                .keyboardType(.numberPad)
                .frame(width: 30, height: 30)
                .background(colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray6))
                .foregroundColor(.primary)
                .cornerRadius(5)
                .padding(.leading)

            if isLoading {
                ActivityView()
            } else {
                Button(action: action) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .disabled(isSendButtonDisabled)
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

struct DocumentPicker: UIViewControllerRepresentable {
    var didPickDocument: (URL) -> Void

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.didPickDocument(urls[0])
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) { }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) { }
}

#if canImport(UIKit)
extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
