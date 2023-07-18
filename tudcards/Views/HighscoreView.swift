//
//  HighscoreView.swift
//  tudcards
//
//  Created by Leon on 17.07.23.
//

import Foundation
import SwiftUI

struct HighscoreView: View {
    @EnvironmentObject var categoryViewModel: CategoryViewModel

    var body: some View {
        List {
            ForEach(categoryViewModel.categories) { category in
                Section(header: Text(category.title)) {
                    ForEach(category.flashcards) { flashcard in
                        HStack {
                            Text(flashcard.question)
                            Spacer()
                            if let correct = flashcard.correct {
                                Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(correct ? .green : .red)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Highscore")
    }
}

