//
//  Sendable.swift
//  Swift-Concurrency
//
//  Created by Sahil Saini on 19/02/26.
//
/*
 

actor ContactsStore {
    private(set) var contacts: [Contact] = []

    func add(_ contacts: [Contact]) {
        self.contacts.append(contentsOf: contacts)
    }

    func removeAll(_ shouldBeRemoved: (Contact) -> Bool) async {
        contacts.removeAll { contact in
            return shouldBeRemoved(contact)
        }
    }
}
 
 // Check non sendable class
 // in struct with region based isolation
 class Article {
     var title: String

     init(title: String) {
         self.title = title
     }
 }
 struct SendableChecker: Sendable {
     func check() {
         let article = Article(title: "Swift Concurrency")

         Task {
             print(article.title)
         }
 
    print here
     }
 }
 
 
 
 // Sending keyword
 actor ArticleTitleLogger {
     func log(article: Article) {
         print(article.title)
     }
 }
 
 func printArticleTitle(article: sending Article) async {
     let articleTitleLogger = ArticleTitleLogger()
     await articleTitleLogger.log(article: article)
 }
 
 
 func sendingParameterValueCheck() async {
     let article = Article(title: "Swift Concurrency")

     await printArticleTitle(article: article)
 }

 func printArticleTitle(article: sending Article) async {
     let articleTitleLogger = ArticleTitleLogger()
     await articleTitleLogger.log(article: article)
 }
 
 @SomeGlobalActor
 func createArticle(title: String) -> sending Article {
     return Article(title: title)
 }
 
 
*/
