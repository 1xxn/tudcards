//
//  FlashcardModel.swift
//  tudcards
//
//  Created by Leon on 14.07.23.
//

import Foundation

// define the category with id, title, module and flashcard
struct Category: Identifiable {
    let id: UUID
    var title: String
    var module: String
    var flashcards: [Flashcard]
}

// define flashcard with id, question and answer
struct Flashcard: Identifiable {
    let id: UUID
    var question: String
    var answer: String
}