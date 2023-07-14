//
//  FlashcardViewModel.swift
//  tudcards
//
//  Created by Leon on 14.07.23.
//

/*import Foundation

class FlashcardViewModel: ObservableObject {
    @Published var flashcards: [Flashcard] = []
    @Published var categories: [Category] = []

    
    // function to create new flashcard in a category
    func createFlashcard(in category: Category, question: String, answer: String) {
        let newFlashcard = Flashcard(id: UUID(), question: question, answer: answer)
        
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index].flashcards.append(newFlashcard)
        }
    }
    
    // function to update existing flashcard
    func updateFlashcard(_ flashcard: Flashcard, withQuestion question: String, answer: String) {
        if let index = flashcards.firstIndex(where: { $0.id == flashcard.id }) {
            flashcards[index].question = question
            flashcards[index].answer = answer
        }
    }
    
    // function to delete flashcard
    func deleteFlashcard(in category: Category, at indexSet: IndexSet) {
        if let categoryIndex = getCategoryIndex(category) {
            categories[categoryIndex].flashcards.remove(atOffsets: indexSet)
        }
    }
    
    // help function to get index of a category in the categories array
    private func getCategoryIndex(_ category: Category) -> Int? {
        return categories.firstIndex { $0.id == category.id }
    }
}
*/
