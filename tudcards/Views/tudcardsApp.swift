//
//  tudcardsApp.swift
//  tudcards
//
//  Created by Leon on 14.07.23.
//

import SwiftUI

@main
struct tudcardsApp: App {
    @StateObject private var categoryViewModel = CategoryViewModel()
    
    var body: some Scene {
        WindowGroup {
            CategoryListView()
                .environmentObject(categoryViewModel)
        }
    }
}
