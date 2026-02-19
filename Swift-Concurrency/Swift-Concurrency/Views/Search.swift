//
//  Search.swift
//  Swift-Concurrency
//
//  Created by Sahil Saini on 19/02/26.
//

import SwiftUI

@MainActor
@Observable
final class ArticleSearcher {

    private static let articleTitlesDatabase = [
        "Article one",
        "Article two",
        "Article three",
    ]

    var searchResults: [String] = ArticleSearcher.articleTitlesDatabase

    private var currentSearchTask: Task<Void, Never>?

    func search(_ query: String) {
        /// Cancel any previous searches that might be 'sleeping'.
        currentSearchTask?.cancel()

        currentSearchTask = Task {
            do {
                /// Sleep for 0.5 seconds to wait for a pause in typing before executing the search.
                try await Task.sleep(for: .milliseconds(500))

                print("Starting to search!")

                /// A simplified static result and search implementation.
                searchResults = Self.articleTitlesDatabase
                    .filter { $0.lowercased().contains(query.lowercased()) }
            } catch {
                print("Search was cancelled!")
            }
        }
    }
    /*
     
      TODO:
     1. update task with id
     2. set task priority
     3. check if priority can be dynamic
     4. default task priority is `userInitiated`
     func search(_ query: String) async {
         do {
             /// Sleep for 0.5 seconds to wait for a pause in typing before executing the search.
             try await Task.sleep(for: .milliseconds(500))

             print("Starting to search!")

             /// A simplified static result and search implementation.
             searchResults = Self.articleTitlesDatabase
                 .filter { $0.lowercased().contains(query.lowercased()) }
         } catch {
             print("Search was cancelled!")
         }
     }
     struct SearchArticleTaskModifierView: View {
         @State private var searchQuery = ""
         @State private var articleSearcher = ArticleSearcher()

         var body: some View {
             NavigationStack {
                 List {
                     ForEach(articleSearcher.searchResults, id: \.self) { title in
                         Text(title)
                     }
                 }
             }
             .searchable(text: $searchQuery)
             .task {
                 await articleSearcher.search(searchQuery)
             }
         }
     }
     */
}


struct SearchArticleView: View {
    @State private var searchQuery = ""
    @State private var articleSearcher = ArticleSearcher()

    var body: some View {
        NavigationStack {
            List {
                ForEach(articleSearcher.searchResults, id: \.self) { title in
                    Text(title)
                }
            }
        }
        .searchable(text: $searchQuery)
        .onChange(of: searchQuery) { oldValue, newValue in
            articleSearcher.search(newValue)
        }
    }
}
