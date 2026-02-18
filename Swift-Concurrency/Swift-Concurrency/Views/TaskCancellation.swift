//
//  TaskCancellation.swift
//  Swift-Concurrency
//
//  Created by Sahil Saini on 18/02/26.
//

import SwiftUI
struct ContentView1: View {
    @State var image: UIImage?

    var body: some View {
        VStack {
            if let image {
                Image(uiImage: image)
            } else {
                Text("Loading...")
            }
        }.onAppear {
            Task {
                do {
                    image = try await fetchImage()
                    print("Image loading completed")
                } catch {
                    print("Image loading failed: \(error)")
                }
            }
        }
    }

    func fetchImage() async throws -> UIImage? {
        let imageTask = Task { () -> UIImage? in
            let imageURL = URL(string: "https://httpbin.org/image")!
            var imageRequest = URLRequest(url: imageURL)
            imageRequest.allHTTPHeaderFields = ["accept": "image/jpeg"]
            try Task.checkCancellation()
            print("Starting network request...")
            let (imageData, _) = try await URLSession.shared.data(for: imageRequest)

            return UIImage(data: imageData)
        }
        imageTask.cancel()
        return try await imageTask.value
    }
    
//    let throwingTask: Task<String, URLError> = Task { () -> String in
//        throw URLError(error: .badURL)
//    }
    
    enum URLError: Error {
        init(error: URLError) {
            self = error
        }
        case badURL
    }
}

/*
 Another benefit is that the task gets scheduled on the cooperative pool as early as possible—sooner than if you were to start it inside an onAppear closure. However, the exact execution time still depends on the underlying task executor. As a result, regular code within onAppear might run earlier. This isn’t a contradiction—it simply reflects the timing decisions made by the executor. The following code illustrates this behavior:
 
SomeView()
    .task(priority: .high, {
        /// Executes earlier than a task scheduled inside `onAppaer`.
        print("1")
    })
    .onAppear {
        /// Scheduled later than using the `task` modifier which
        /// adds an asynchronous task to perform before the view appears.
        Task(priority: .high) { print("2") }

        /// Regular code inside `onAppear` might appear to run earlier than a `Task`.
        /// This is due to the task executor scheduler.
        print("3")
    }
 
 
 func parentTaskExample() async {
     let handle = Task {
         print("Parent task started")

         async let childTask1 = someWork(id: 1)
         async let childTask2 = someWork(id: 2)

         let finishedTaskIDs = try await [childTask1, childTask2]
         print(finishedTaskIDs)
     }

     /// Cancel parent task after a short delay of 0.5 seconds.
     try? await Task.sleep(nanoseconds: 500_000_000)

     /// This cancels both childTask1 and childTask2:
     handle.cancel()

     /// Wait for the parent task and notice how cancellation propagates.
     try? await handle.value
     print("Parent task finished")
 }

 func someWork(id: Int) async throws -> Int {
     for i in 1...5 {
         /// Check for cancellation and throw an error if detected.
         try Task.checkCancellation()
         print("Child task \(id): Step \(i)")

         /// Sleep for 0.4 seconds.
         try await Task.sleep(nanoseconds: 400_000_000)
     }

     return id
 }
*/
#Preview {
    ContentView1()
}
