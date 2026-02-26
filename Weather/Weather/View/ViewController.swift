//
//  ViewController.swift
//  Weather
//
//  Created by Jorgen Boring on 26/02/2026.
//

import UIKit

class ViewController: UIViewController {

    private let weatherService = NetworkRequest()
    private let locationManager = LocationManager()
    
    @IBAction func checkWeather(_ sender: Any) {
        Task {
            do {
                let locationData = try await locationManager.getCurrentLocation()
                print(try await weatherService.requestToServer(lat: String(locationData.coordinate.latitude), lon: String(locationData.coordinate.longitude)))
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

