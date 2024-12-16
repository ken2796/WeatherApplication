//
//  WeatherResultView.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import SwiftUI

struct WeatherResultView: View {
    
    var weather: WeatherData?
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let urlString = weather?.current?.condition.iconURL,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 130, height: 130)
            }
            
            HStack {
                if let locationName = weather?.location.name {
                    Text(locationName)
                        .font(Font.custom("Poppins-SemiBold", size: 30))
                    Image("locationArrow")
                }
            }
            HStack(spacing: -10) {
                if let temperature = weather?.current?.tempC {
                    Text(String(format:"%.0f", temperature))
                        .font(Font.custom("Poppins-Medium", size: 70))
                        .padding()
                    Text("°")
                        .font(Font.custom("Poppins-Medium", size: 20))
                        .padding(.top, -40)
                }
            }
            
            VStack {
                HStack(spacing: 50) {
                    if let weatherData = weather?.current {
                        currentWeather(text: StringsConstants.humidity, weather: String(weatherData.humidity ?? 0) + "%")
                        
                        currentWeather(text: StringsConstants.uv, weather: (String(format:"%.0f", weatherData.uv ?? 0)))
                        
                        currentWeather(text: StringsConstants.feelLike, weather: String(format:"%.0f°",weatherData.feelslikeC ?? 0))
                    }
                }
                .frame(width: 274, height: 75)
            }
            .background(Color.colorSearchBarBackground)
            .cornerRadius(16)
        }
    }
    
    func currentWeather(text: String, weather: String) -> some View {
        VStack {
            Text(text)
                .foregroundStyle(Color.waText)
                .font(Font.custom("Poppins-Medium", size: 12))
            Text(weather)
                .foregroundStyle(Color.waText)
                .font(Font.custom("Poppins-Medium", size: 15))
        }
    }
}

#Preview {
    WeatherResultView()
}
