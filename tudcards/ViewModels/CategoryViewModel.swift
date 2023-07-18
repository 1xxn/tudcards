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
        saveData()
    }
    
    // function to delete category
    func deleteCategory(at indexSet: IndexSet) {
        categories.remove(atOffsets: indexSet)
        saveData()
    }
    
    // function for update category
    func updateCategory(_ category: Category, withTitle title: String) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index].title = title
        }
        saveData()
    }
    
    // function to create flashcards
    func createFlashcard(in category: Category, question: String, answer: String) {
        guard let categoryIndex = categories.firstIndex(where: { $0.id == category.id }) else { return }
        let newFlashcard = Flashcard(id: UUID(), question: question, answer: answer)
        categories[categoryIndex].flashcards.append(newFlashcard)
        saveData()
    }
    
    // function to delete flashcards
    func deleteFlashcard(in category: Category, at indexSet: IndexSet) {
        guard let categoryIndex = categories.firstIndex(where: { $0.id == category.id }) else { return }
        categories[categoryIndex].flashcards.remove(atOffsets: indexSet)
        saveData()
    }
    
    // function to save categories and flashcards
    func saveData() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("categories.json")
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(categories)
            try data.write(to: fileURL)
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    // function to load categories and flashcards
    func loadData() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("categories.json")
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL)
            let loadedCategories = try decoder.decode([Category].self, from: data)
            categories = loadedCategories
        } catch {
            print("Error loading data: \(error)")
        }
    }
    
    // function to mark flashcards
    func markFlashcard(_ flashcard: Flashcard, as correct: Bool) {
        for (i, category) in categories.enumerated() {
            if let index = category.flashcards.firstIndex(where: { $0.id == flashcard.id }) {
                categories[i].flashcards[index].correct = correct
            }
        }
        saveData()
    }
}
