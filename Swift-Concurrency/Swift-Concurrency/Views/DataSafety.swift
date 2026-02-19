//
//  DataSafety.swift
//  Swift-Concurrency
//
//  Created by Sahil Saini on 19/02/26.
//
/*
var counter = 0
let queue = DispatchQueue.global(qos: .background)

for _ in 1...10 {
    queue.async {
       counter += 1
    }
}

print("Final counter value: \(counter)")


solution 1
 var counter = 0
 let serialQueue = DispatchQueue(label: "com.example.serial")

 for _ in 1...10 {
     serialQueue.async {
         counter += 1
     }
 }

 serialQueue.async {
     print("Final counter value: \(counter)")
 }
 
 
 solution 2
 
 actor Counter {
     private var value = 0

     func increment() {
         value += 1
     }

     func getValue() -> Int {
         return value
     }
 }
 let counter = Counter()

 for _ in 1...10 {
     await counter.increment() // Safely increments the counter
 }

 /// Safe read using `await`
 print("Final counter value: \(await counter.getValue())")
 
 
 Data race
 //
 //
 // A race condition occurs when multiple threads access shared data concurrently, leading to unpredictable behavior due to the timing of their execution. It often results in inconsistent or incorrect outcomes if proper synchronization mechanisms aren’t used.
 // Each increment performs asynchronously and there’s no guarantee that all increments complete before we read out the final counter value.
 
 let counter = Counter()

 for _ in 1...10 {
     Task {
         await counter.increment() // Safely increments the counter
     }
 }

 /// Safe read using `await`
 print("Final counter value: \(await counter.getValue())")
*/
