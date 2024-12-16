//
//  WeatherViewModel.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import Foundation
import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var locationName: String = ""
    @Published var clickSearchData: Bool = false
    @Published var weather: WeatherData?
    
    @AppStorage("weatherResults") private var savedWeatherData: Data?
    
    init() {
        loadWeatherData()
    }
    
    func getWeatherData(locations: String) async {
        isLoading = true
        do {
            let fetchedWeather = try await URLSessionProvider.shared.request(WeatherData.self, service: WeatherService.getCurrentWeather(locations))
            self.isLoading = false
            weather = fetchedWeather
        } catch {
            self.isLoading = false
            weather = nil
            print("FAILED TO FETCH \(error)")
        }
    }
    
    func saveToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(weather) {
            savedWeatherData = encodedData
        }
    }

    func loadWeatherData() {
        if let savedData = savedWeatherData,
           let decodedWeather = try? JSONDecoder().decode(WeatherData.self, from: savedData) {
            weather = decodedWeather
        }
    }
}
