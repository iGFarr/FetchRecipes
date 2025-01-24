//
//  RecipeListView.swift
//  FetchRecipes
//
//  Created by Isaac Farr on 1/23/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var searchText = ""
    @State private var isSearchBarVisible = false
    @State private var isSortScreenPresented = false
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.filteredRecipes.isEmpty {
                    // Used a list here to retain pull-to-refresh ability. Text for empty data set.
                    List(["No recipes found."], id: \.self) { text in
                        Text(text)
                            .font(.headline)
                            .listRowBackground(Color(.clear))
                    }
                } else {
                    // Show the recipe list when there are recipes
                    List(viewModel.filteredRecipes) { recipe in
                        RecipeListItem(recipe: recipe)
                    }
                }
            }
            .navigationTitle("Fetch: Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isSortScreenPresented = true
                    }) {
                        Image(systemName: "arrow.up.arrow.down.circle")
                    }
                }
                ToolbarItem(placement: .principal) {
                    if isSearchBarVisible {
                        TextField("Search recipes", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isSearchFieldFocused)
                            .onChange(of: searchText) { newValue in
                                viewModel.filterRecipes(by: newValue)
                            }
                            .onSubmit {
                                isSearchBarVisible = false
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isSearchBarVisible.toggle()
                            if isSearchBarVisible {
                                isSearchFieldFocused = true
                            } else {
                                searchText = ""
                                viewModel.filterRecipes(by: searchText)
                            }
                        }
                    }) {
                        Image(systemName: isSearchBarVisible ? "xmark.circle.fill" : "magnifyingglass")
                    }
                }
            }
            .sheet(isPresented: $isSortScreenPresented) {
                SortOptionsView(
                    currentSortOption: viewModel.currentSortOption,
                    onSortSelected: { sortOption in
                        viewModel.sortRecipes(by: sortOption)
                    }
                )
            }
            .refreshable {
                await viewModel.fetchRecipes()
            }
            .task {
                await viewModel.fetchRecipes()
            }
            .alert(item: $viewModel.errorMessage) { error in
                Alert(title: Text("Error"), message: Text(error.value), dismissButton: .default(Text("OK")))
            }
        }
        
    }
}
