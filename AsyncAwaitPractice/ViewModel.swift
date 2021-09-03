//
//  ViewModel.swift
//  ViewModel
//
//  Created by Erik Flores on 2/9/21.
//

import Foundation

struct ViewModel {
    func getData() async throws  -> APIResponse {
        let url = URL(string: "https://rickandmortyapi.com/api")!
        let (data, urlResponse) = try await URLSession.shared.data(from: url, delegate: nil)
        print("urlResponse \(urlResponse)")
        let dataResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        return dataResponse
    }

    func getSecuenceData() async throws {
        let apiResponse = try await getData()
        let (character,_) = try await URLSession.shared.data(from: URL(string: apiResponse.characters)!, delegate: nil)
        let (locations,_) = try await URLSession.shared.data(from: URL(string: apiResponse.locations)!, delegate: nil)
        let (episodes,_) = try await URLSession.shared.data(from: URL(string: apiResponse.episodes)!, delegate: nil)

        print("character \(character)")
        print("episodes \(episodes)")
        print("locations \(locations)")
    }

    func getDataInParalallel() async throws {
        let apiResponse = try await getData()
        async let (character,_) = try await URLSession.shared.data(from: URL(string: apiResponse.characters)!, delegate: nil)
        async let (locations,_) = try await URLSession.shared.data(from: URL(string: apiResponse.locations)!, delegate: nil)
        async let (episodes,_) = try await URLSession.shared.data(from: URL(string: apiResponse.episodes)!, delegate: nil)

        let result = try await [character, episodes ,locations]
        print(result)
    }
}
