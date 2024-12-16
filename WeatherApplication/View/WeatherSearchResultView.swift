//
//  WeatherResulView.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import SwiftUI

struct WeatherSearchResultView: View {
    
    var weather: WeatherData?
    
    var body: some View {
        VStack {
            HStack(spacing: 100) {
                VStack(spacing: -10) {
                    if let location = weather?.location.name, let temperature = weather?.current?.tempC {
                        Text(location)
                            .font(Font.custom("Poppins-SemiBold", size: 20))
                        HStack(spacing: 1) {
                            Text(String(format:"%.0f",temperature))
                                .font(Font.custom("Poppins-Medium", size: 60))
                            Text("°")
                                .font(Font.custom("Poppins-Medium", size: 20))
                                .padding(.top, -35)
                        }
                    }
                }
                .padding(.leading, 10)
                .padding(.top, 10)
                
                if let urlString = weather?.current?.condition.iconURL,
                   let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 100, height: 100)
                    
                }
                    
            }
            .frame(width: 336, height: 117)
        }
        .background(Color.colorSearchBarBackground)
        .cornerRadius(16)
    }
}

#Preview {
    WeatherSearchResultView()
}
