import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var searchText = ""
    @State private var isSearchBarVisible = false
    @State private var isSortScreenPresented = false
    private let imageCache = ImageCache()

    var body: some View {
        NavigationView {
            VStack {
                // Conditional Search Bar
                if isSearchBarVisible {
                    TextField("Search recipes by name", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onChange(of: searchText) { _, newValue in
                            viewModel.filterRecipes(by: newValue)
                        }
                        .onSubmit {
                            isSearchBarVisible = false // Hide search bar when user finishes entering text
                        }
                }

                // Recipe List
                List(viewModel.filteredRecipes) { recipe in
                    RecipeListItem(recipe: recipe)
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isSearchBarVisible.toggle() // Toggle visibility
                            if !isSearchBarVisible {
                                searchText = "" // Clear search text when hiding the bar
                                viewModel.filterRecipes(by: searchText) // Reset the filtered list
                            }
                        }
                    }) {
                        Image(systemName: isSearchBarVisible ? "xmark.circle.fill" : "magnifyingglass")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isSortScreenPresented = true // Show the sort screen
                    }) {
                        Image(systemName: "arrow.up.arrow.down.circle")
                    }
                }
            }
            .sheet(isPresented: $isSortScreenPresented) {
                SortOptionsView(
                    currentSortOption: viewModel.currentSortOption, // Pass current sort option
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
