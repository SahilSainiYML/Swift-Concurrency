//
//  APIProvider.swift
//  Swift-Concurrency
//
//  Created by Sahil Saini on 17/02/26.
//
import Foundation

struct APIProvider {
    func postURLRequest() async throws(NetworkingError) -> PostData {
        do {
            let url = URL(string: "https://httpbin.org/post")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // Define the struct of data and encode it to data.
            let postData = PostData(name: "Antoine van der Lee", age: 34)
            request.httpBody = try JSONEncoder().encode(postData)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw NetworkingError.invalidStatusCode(statusCode: -1)
            }

            guard (200...299).contains(statusCode) else {
                throw NetworkingError.invalidStatusCode(statusCode: statusCode)
            }
            let decodedResponse = try JSONDecoder().decode(PostResponse.self, from: data)
            print("The JSON response contains a name: \(decodedResponse.json.name) and an age: \(decodedResponse.json.age)")
            return decodedResponse.json
        } catch let error as DecodingError {
            throw .decodingFailed(innerError: error)
        } catch let error as EncodingError {
            throw .encodingFailed(innerError: error)
        } catch let error as URLError {
            throw .requestFailed(innerError: error)
        } catch let error as NetworkingError {
            throw error
        } catch {
            throw .otherError(innerError: error)
        }
        
    }
    
    //Old way with closure
    func postURLRequest(completion: @escaping (Result<PostData, NetworkingError>) -> Void) {
        let url = URL(string: "https://httpbin.org/post")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Define the struct of data and encode it to data.
        let postData = PostData(name: "Antoine van der Lee", age: 34)
        
        /// Configure the JSON body and catch any failures if needed.
        do {
            request.httpBody = try JSONEncoder().encode(postData)
        } catch let error as EncodingError {
            completion(.failure(.encodingFailed(innerError: error)))
            return
        } catch {
            completion(.failure(.otherError(innerError: error)))
            return
        }
        /// Use URLSession to fetch the data asynchronously.
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let error {
                    throw error
                }
                
                guard let data, let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkingError.invalidResponse
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkingError.invalidStatusCode(statusCode: httpResponse.statusCode)
                }
                
                let decodedResponse = try JSONDecoder().decode(PostResponse.self, from: data)
                print("The JSON response contains a name: \(decodedResponse.json.name) and an age: \(decodedResponse.json.age)")
                
                /// Make sure to send a completion with the success result.
                completion(.success(decodedResponse.json))
            } catch let error as DecodingError {
                completion(.failure(.decodingFailed(innerError: error)))
            } catch let error as EncodingError {
                completion(.failure(.encodingFailed(innerError: error)))
            } catch let error as URLError {
                completion(.failure(.requestFailed(innerError: error)))
            } catch let error as NetworkingError {
                completion(.failure(error))
            } catch {
                completion(.failure(.otherError(innerError: error)))
            }
        }.resume()
    }
}

enum NetworkingError: Error {
    /// Used in both async/await and closure-based requests:
    case encodingFailed(innerError: EncodingError)
    case decodingFailed(innerError: DecodingError)
    case invalidStatusCode(statusCode: Int)
    case requestFailed(innerError: URLError)
    case otherError(innerError: Error)

    /// Only needed for closure based handling:
    case invalidResponse
}

/// Define a struct to represent the data you want to send
struct PostData: Codable {
    let name: String
    let age: Int
}

/// Define a struct to handle the response from `httpbin.org`.
struct PostResponse: Decodable {

    /// In this case, we can reuse the same `PostData` struct as
    /// httpbin returns the received data equally.
    let json: PostData
}


final class SomeTaskExecutor {
    func someSynchronousMethod() {
        // Inner logic...
    }

    func someAsynchronousMethod() async {
        // Inner logic...
    }
    
    var currentTask: Task<Void, Never>?

    func execute() {
        /// Store a reference to the task.
        currentTask = Task {
            await someAsynchronousMethod()
        }
    }

    deinit {
        /// Cancel the task when the outer instance is being deinitialized.
        currentTask?.cancel()
    }
}
