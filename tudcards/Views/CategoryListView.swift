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
    @State private var isPresentingChatView = false
    @State private var isPresentingHighscoreView = false
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
            .listStyle(.plain)
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isPresentingChatView.toggle()
                    }) {
                        Image(systemName: "message.fill")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isPresentingHighscoreView.toggle()
                    }) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
                
                /*ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }*/
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresentingCategorySheet.toggle()
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.green)
                    }
                }
            }
            .sheet(isPresented: $isPresentingCategorySheet) {
                CategorySheet(categoryViewModel: categoryViewModel, isPresented: $isPresentingCategorySheet)
            }
            .sheet(isPresented: $isPresentingChatView) {
                ChatView(categoryViewModel: categoryViewModel)
            }
            .sheet(isPresented: $isPresentingHighscoreView) {
                HighscoreView()
                    .environmentObject(categoryViewModel)
            }
        }
    }

    struct CategorySheet: View {
        @ObservedObject var categoryViewModel: CategoryViewModel
        @Environment(\.colorScheme) var colorScheme
        @Binding var isPresented: Bool
        @State private var newCategoryTitle = ""
        @State private var module = ""

        var body: some View {
            NavigationView {
                VStack {
                    TextField("New Category Title", text: $newCategoryTitle)
                        .padding(10)
                        .foregroundColor(.primary)
                        .background(colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray6))
                        .cornerRadius(10)
                        .frame(minHeight: 75)
                        .padding(.horizontal)


                    Button(action: {
                        categoryViewModel.createCategory(title: newCategoryTitle, module: module)
                        isPresented = false
                    }) {
                        Text("Create")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .disabled(newCategoryTitle.isEmpty)
                    }
                }
                .navigationTitle("New Category")
                .navigationBarTitleDisplayMode(.inline)
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


    struct CategoryPreview: PreviewProvider {
        static var previews: some View {
            CategoryListView()
                .environmentObject(CategoryViewModel())
        }
    }
}
