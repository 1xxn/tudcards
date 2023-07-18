//
//  FlashcardListView.swift
//  tudcards
//
//  Created by Leon on 14.07.23.
//

import SwiftUI

struct FlashcardListView: View {
    var category: Category
    @Namespace private var cardNamespace
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var isPresentingFlashcardSheet = false
    @State private var newFlashcardQuestion = ""
    @State private var newFlashcardAnswer = ""
    @State private var isRemixMode = false
    @State private var isLoopEnabled = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        if isRemixMode {
            VStack {
                if let flashcards = categoryViewModel.categories.first(where: { $0.id == category.id })?.flashcards.shuffled() {
                    FlashcardRemixView(flashcards: flashcards, categoryViewModel: categoryViewModel)
                }
            }
            .navigationTitle(category.title)
            .navigationBarItems(trailing: Button(action: { isRemixMode.toggle() }) {
                Image(systemName: "checkmark")
                        .foregroundColor(.green)
            })
        } else {
            List {
                ForEach(categoryViewModel.categories.first(where: { $0.id == category.id })?.flashcards ?? []) { flashcard in
                    NavigationLink(destination: FlashcardDetailView(flashcard: flashcard, isLoopEnabled: isLoopEnabled)
                        .matchedGeometryEffect(id: flashcard.id, in: cardNamespace)) {
                            Text(flashcard.question)
                        }
                }
                .onDelete(perform: { indexSet in
                    categoryViewModel.deleteFlashcard(in: category, at: indexSet)
                })
            }
            .navigationTitle(category.title)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.backward")
                    .foregroundColor(.blue)
            }, trailing: HStack {
                Button(action: {
                    isRemixMode.toggle()
                }) {
                    Image(systemName: "shuffle")
                        .foregroundColor(.purple)
                }
                Button(action: {
                    isPresentingFlashcardSheet.toggle()
                    // Show a sheet or navigate to a view to create a new flashcard
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                }
            })
            .sheet(isPresented: $isPresentingFlashcardSheet) {
                FlashcardSheet(category: category, isPresented: $isPresentingFlashcardSheet)
                    .environmentObject(categoryViewModel)
            }
        }
    }
    
    struct FlashcardSheet: View {
        var category: Category
        @EnvironmentObject var categoryViewModel: CategoryViewModel
        @Binding var isPresented: Bool
        @State private var newFlashcardQuestion = ""
        @State private var newFlashcardAnswer = ""
        
        
        var body: some View {
            NavigationView {
                VStack {
                    TextField("Question", text: $newFlashcardQuestion)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Answer", text: $newFlashcardAnswer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        categoryViewModel.createFlashcard(in: category, question: newFlashcardQuestion, answer: newFlashcardAnswer)
                        isPresented = false
                    }) {
                        Text("Create")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()
                    .disabled(newFlashcardQuestion.isEmpty || newFlashcardAnswer.isEmpty)
                }
                .navigationTitle("New Flashcard")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
    }
}
