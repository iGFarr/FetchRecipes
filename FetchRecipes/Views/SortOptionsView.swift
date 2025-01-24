//
//  SortOptionsView.swift
//  FetchRecipes
//
//  Created by Isaac Farr on 1/23/25.
//


import SwiftUI

enum SortOption: String, CaseIterable {
    case nameAsc = "Name (A-Z)"
    case nameDesc = "Name (Z-A)"
    case cuisineAsc = "Cuisine (A-Z)"
    case cuisineDesc = "Cuisine (Z-A)"
}

struct SortOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSortOption: SortOption
    var onSortSelected: (SortOption) -> Void

    init(currentSortOption: SortOption, onSortSelected: @escaping (SortOption) -> Void) {
        self._selectedSortOption = State(initialValue: currentSortOption)
        self.onSortSelected = onSortSelected
    }

    var body: some View {
        NavigationView {
            List(SortOption.allCases, id: \.self) { option in
                HStack {
                    Text(option.rawValue)
                    Spacer()
                    if option == selectedSortOption {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedSortOption = option
                }
            }
            .navigationTitle("Sort Options")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        onSortSelected(selectedSortOption) // Notify parent view
                        dismiss()
                    }
                }
            }
        }
    }
}
