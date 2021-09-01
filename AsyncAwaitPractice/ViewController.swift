//
//  ViewController.swift
//  AsyncAwaitPractice
//
//  Created by Erik Flores on 1/9/21.
//

import UIKit

struct APIResponse: Decodable {
    let characters: String
    let locations: String
    let episodes: String
}

struct ViewModel {
    let jsonDecoder = JSONDecoder()

    func getData() async throws  -> APIResponse {
        let url = URL(string: "https://rickandmortyapi.com/api")!
        let (data, urlResponse) = try await URLSession.shared.data(from: url, delegate: nil)
        print("urlResponse \(urlResponse)")
        let dataResponse = try jsonDecoder.decode(APIResponse.self, from: data)
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

    func getDataNewWay() async throws {
        let url = URL(string: "https://rickandmortyapi.com/api")!
        URLSession.shared.dataTask(with: url) { data, response, error in

        }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllData()
    }

    func getAllData() {
        Task {
            do {
                try await viewModel.getSecuenceData()
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }

    func getData() {
        Task {
            do {
                let apiResponse = try await viewModel.getData()
                self.textView.text = apiResponse.characters // xcode doesnt give the main thread checker warning
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}

