//
//  CategoryListView.swift
//  tudcards
//
//  Created by Leon on 14.07.23.
//

import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var isPresentingCategorySheet = false
    @State private var newCategoryTitle = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categoryViewModel.categories) { category in
                    NavigationLink(destination: FlashcardListView(category: category, categoryViewModel: _categoryViewModel)) {
                        Text(category.title)
                    }
                }
                .onDelete(perform: categoryViewModel.deleteCategory)
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isPresentingCategorySheet.toggle()
                        // Show a sheet or navigate to a view to create a new category
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingCategorySheet) {
                CategorySheet(categoryViewModel: categoryViewModel, isPresented: $isPresentingCategorySheet)
            }
        }
    }
}

struct CategorySheet: View {
    @ObservedObject var categoryViewModel: CategoryViewModel
    @Binding var isPresented: Bool
    @State private var newCategoryTitle = ""
    @State private var module = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Category Title", text: $newCategoryTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    categoryViewModel.createCategory(title: newCategoryTitle, module: module)
                    isPresented = false
                }) {
                    Text("Create")
                }
                .padding()
                .disabled(newCategoryTitle.isEmpty)
            }
            .navigationTitle("New Category")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}


struct CategoryPreview: PreviewProvider {
    static var previews: some View {
        CategoryListView()
            .environmentObject(CategoryViewModel())
    }
}
