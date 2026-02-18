//
//  DetachedTask.swift
//  Swift-Concurrency
//
//  Created by Sahil Saini on 18/02/26.
//

import SwiftUI

/*
 A few things are worth pointing out:

 We create the detached task after the first long running task. Even though we cancel the task immediately, it still gets executed.
 The sleep inside the first long running task respects the cancellation within the local task context. This is because we execute the async method from within the task that got cancelled.
 While we perform a try Task.checkCancellation() inside the detached task, it does not result in a cancellation. This truly demonstrates how detached tasks work in a new context.
 
#Preview {
    func detachedTasksExample() async {
        await asyncPrint("Operation one")
        Task.detached {
            /// Runs the given nonthrowing operation asynchronously as part of a new top-level task.
            await asyncPrint("Operation two")
        }
        await asyncPrint("Operation three")
        
        func asyncPrint(_ string: String) async {
            print(string)
        }
        
        // Potentially prints, the order is not guaranteed to be the same every time:
        // Operation one
        // Operation three
        // Operation two
    }
    /// Faking a long running task by using a `Task.sleep`
    func longRunningAsyncOperation() async {
        do {
            try await Task.sleep(for: .seconds(5))
        } catch {
            print("\(#function) failed with error: \(error)")
        }
    }
    
    let outerTask = Task {
        /// This one will cancel.
        print("Start longRunningAsyncOperation 1")
        await longRunningAsyncOperation()
        
        /// This detached task won't cancel.
        Task.detached(priority: .background) {
            try Task.checkCancellation()
            
            /// And, therefore, this task won't cancel either.
            print("Start longRunningAsyncOperation 2")
            await longRunningAsyncOperation()
        }
    }
    outerTask.cancel()
}
 */
