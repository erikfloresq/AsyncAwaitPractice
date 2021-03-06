//
//  ViewController.swift
//  AsyncAwaitPractice
//
//  Created by Erik Flores on 1/9/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    let viewModel = ViewModel()
    let viewModelWithWrapper = ViewModelWithWrappers()

    override func viewDidLoad() {
        super.viewDidLoad()
        //getAllDataInParallel()
        getInGroup()
    }

    func getInGroup() {
        Task {
            do {
                let responseGroup = try await viewModel.getInGroup()
                self.textView.text = "\(responseGroup)"
            } catch {
                print("")
            }
        }
    }

    func getAllDataInParallel() {
        Task {
            do {
                try await viewModel.getDataInParallel()
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }

    func getSequentialData() {
        Task {
            do {
                try await viewModel.getSequentialData()
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }

    func getMoreData() {
        Task {
            do {
                let apiResponse = try await viewModelWithWrapper.getDataWithNewWay()
                self.textView.text = apiResponse?.locations
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }

    func getData() {
        Task {
            do {
                let apiResponse = try await viewModel.getData()
                self.textView.text = apiResponse.characters // xcode doesnt give the main thread checker warning, this is for UITextView has @MainActor
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}

