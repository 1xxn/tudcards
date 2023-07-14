//
//  CategoryViewModel.swift
//  tudcards
//
//  Created by Leon on 14.07.23.
//

import Foundation

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    
    // function to create new category
    func createCategory(title: String, module: String) {
        let newCategory = Category(id: UUID(), title: title, module: module, flashcards: [])
        categories.append(newCategory)
    }
    
    // function to delete category
    func deleteCategory(at indexSet: IndexSet) {
        categories.remove(atOffsets: indexSet)
    }
    
    // function for update category
    func updateCategory(_ category: Category, withTitle title: String) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index].title = title
        }
    }
    
    func createFlashcard(in category: Category, question: String, answer: String) {
            guard let categoryIndex = categories.firstIndex(where: { $0.id == category.id }) else { return }
            let newFlashcard = Flashcard(id: UUID(), question: question, answer: answer)
            categories[categoryIndex].flashcards.append(newFlashcard)
        }
        
        func deleteFlashcard(in category: Category, at indexSet: IndexSet) {
            guard let categoryIndex = categories.firstIndex(where: { $0.id == category.id }) else { return }
            categories[categoryIndex].flashcards.remove(atOffsets: indexSet)
        }
}
