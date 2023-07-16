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
                .onAppear {
                    categoryViewModel.loadData()
                }
                .onChange(of: UIApplication.shared.applicationState) { state in
                    if state == .background {
                        categoryViewModel.saveData()
                    }
                }
        }
    }
    
    // load data when app launches
    init() {
        categoryViewModel.loadData()
    }
    
    // save data when app terminates
    func saveData() {
        categoryViewModel.saveData()
    }
}
