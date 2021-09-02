//
//  ViewModelWithWrappers.swift
//  ViewModelWithWrappers
//
//  Created by Erik Flores on 2/9/21.
//

import Foundation

class ViewModelWithWrappers {
    func getDataOldWay(completionHandler: @escaping (Result<Data?, Error>) -> Void) {
        let url = URL(string: "https://rickandmortyapi.com/api")!
        URLSession.shared.dataTask(with: url) { data, response, responseError in
            if let error = responseError {
                completionHandler(.failure(error))
            }
            completionHandler(.success(data))
        }.resume()
    }

    func getDataNewWay() async throws -> Data? {
        try await withCheckedThrowingContinuation({ continuation in
            getDataOldWay { result in
                switch result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        })
    }

    func getDataWithNewWay() async throws -> APIResponse? {
        guard let data = try await getDataNewWay() else {
            return nil
        }
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        return apiResponse
    }
}
