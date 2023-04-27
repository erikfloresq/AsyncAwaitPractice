//
//  ViewModel.swift
//  ViewModel
//
//  Created by Erik Flores on 2/9/21.
//

import Foundation
import RickAndMortyAPI

struct ViewModel {
    func getAPIData<T: Decodable>(from url: String) async throws  -> T {
        let enpoint = URL(string: url)!
        let (data, _) = try await URLSession.shared.data(from: enpoint, delegate: nil)
        let dataResponse = try JSONDecoder().decode(T.self, from: data)
        print("Finish \(URLComponents(string: url)?.path)")
        return dataResponse
    }

    func getData() async throws -> RootResponse {
        let rootResponse: RootResponse = try await getAPIData(from: "https://rickandmortyapi.com/api")
        return rootResponse
    }

    func getSequentialData() async throws -> Int {
        let rootResponse: RootResponse = try await getAPIData(from: "https://rickandmortyapi.com/api")
        let locations: ResponseAPI<Location> = try await getAPIData(from: rootResponse.locations)
        let episodes: ResponseAPI<Episode> = try await getAPIData(from: rootResponse.episodes)
        let characters: ResponseAPI<Character> = try await getAPIData(from: rootResponse.characters)

        print("Locations \(locations.results)")
        print("episodes \(episodes.results)")
        print("characters \(characters.results)")
        
        return locations.results.count + episodes.results.count + characters.results.count
    }

    func getDataInParallel() async throws -> Int {
        let rootResponse: RootResponse = try await getAPIData(from: "https://rickandmortyapi.com/api")
        async let locations: ResponseAPI<Location> = getAPIData(from: rootResponse.locations)
        async let episodes: ResponseAPI<Episode> = getAPIData(from: rootResponse.episodes)
        async let characters: ResponseAPI<Character> = getAPIData(from: rootResponse.characters)

        let responses: [Any] = try await [locations, episodes, characters]
        for item in responses {
            print("item \(item)")
        }
        return responses.count
    }

    /// this is for request that has the same result
    func getInGroup() async throws -> [RootResponse] {
        let groupRequest = ["https://rickandmortyapi.com/api", "https://rickandmortyapi.com/api", "https://rickandmortyapi.com/api"]
        return await withTaskGroup(of: RootResponse.self, body: { group in
            var rootResponses = [RootResponse]()
            for request in groupRequest {
                group.addTask {
                    return try! await getAPIData(from: request)
                }
            }
            for await rootResponse in group {
                rootResponses.append(rootResponse)
            }
            return rootResponses
        })
    }
}
