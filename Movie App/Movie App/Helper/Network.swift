//
//  Network.swift
//  Movie App 2
//
//  Created by Gülhan Büşra TOSUN on 5.05.2025.
//

import Foundation

struct Network<T: Codable> {
    struct Model {
        let urlString: String
    }
    
    func request(model: Model, completion: @escaping (T?) -> Void) {
        guard let url = URL(string: model.urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    
                    completion(result)
                } catch {
                    print("Decoding error: \(error)")
                }
            }.resume()
        
        completion(nil)
    }
}
