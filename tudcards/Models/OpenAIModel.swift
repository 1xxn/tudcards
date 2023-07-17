//
//  OpenAIModel.swift
//  tudcards
//
//  Created by Leon on 16.07.23.
//


import Foundation
import ChatGPT

class OpenAIService {
    let chatGPT = ChatGPT(apiKey: "API-KEY", defaultModel: .gpt3)

    func generateFlashcards(prompt: String, numFlashcards: Int, completion: @escaping ([Flashcard]) -> Void) {
        let fullPrompt = "Generate me \(numFlashcards) flashcards in this format:\n\"Q: question\"\n\"A: answer\"\n\(prompt)"
        
        async {
            do {
                let response = try await chatGPT.ask(fullPrompt)
                print("Raw GPT-3 Response: \(response)")
                let flashcards = self.parseGeneratedText(response)
                print("Generated Flashcards: \(flashcards)")
                completion(flashcards)
            } catch {
                print("Error while making request: \(error)")
            }
        }
    }
    
    // parse generated text into flashcards
    private func parseGeneratedText(_ text: String) -> [Flashcard] {
        // split text into lines
        let lines = text.split(separator: "\n")
        // create flashcards from each line
        var flashcards: [Flashcard] = []
        var question: String?
        for line in lines {
            // separate each line into a question and answer
            let components = line.split(separator: ": ", maxSplits: 1)
            if components.count >= 2 {
                let key = String(components[0]).trimmingCharacters(in: .whitespacesAndNewlines)
                let value = String(components[1]).trimmingCharacters(in: .whitespacesAndNewlines)
                if key == "Q" {
                    question = value
                } else if key == "A", let question = question {
                    let flashcard = Flashcard(id: UUID(), question: question, answer: value)
                    flashcards.append(flashcard)
                }
            }
        }
        return flashcards
    }
}
