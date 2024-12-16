//
//  ContentView.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            textFieldAndImage()
            
            if viewModel.isLoading {
                ProgressView("Fetching weather...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                if viewModel.locationName.isEmpty && !viewModel.clickSearchData && viewModel.weather == nil  {
                    Spacer()
                    promptLabel(text: StringsConstants.noCitySelected, size: 30)
                        .padding(.bottom, 5)
                    promptLabel(text: StringsConstants.pleaseSearch, size: 15)
                    Spacer()
                }
            }
            
            if !viewModel.locationName.isEmpty && viewModel.weather != nil {
                WeatherSearchResultView(weather: viewModel.weather)
                    .padding(.top, 10)
                    .onTapGesture {
                        viewModel.clickSearchData = true
                        viewModel.locationName = ""
                        viewModel.saveToUserDefaults()
                    }
               
            }
            if viewModel.weather != nil && viewModel.locationName.isEmpty {
                Spacer()
                WeatherResultView(weather: viewModel.weather)
                
            }
            
            Spacer()
        }
        .padding()
    }
    
    func textFieldAndImage() -> some View {
        ZStack {
            TextField(StringsConstants.searchLocation, text: $viewModel.locationName)
                .font(Font.custom("Poppins-Regular", size: 15))
                .padding()
                .background(Color.colorSearchBarBackground.cornerRadius(16))
                .frame(height: 46)
                .onSubmit {
                    Task {
                        await viewModel.getWeatherData(locations: viewModel.locationName)
                        viewModel.saveToUserDefaults()
                    }
                }
            HStack {
                Spacer()
                Image("searchIcon")
                    .resizable()
                    .frame(width: 17.49, height: 17.49)
                    .foregroundColor(.gray)
                    .padding(.trailing, 20)
            }
        }
    }
    
    func promptLabel(text: String, size: CGFloat) ->  some View {
        Text(text)
            .font(Font.custom("Poppins-SemiBold", size: size))
    }
}

#Preview {
    WeatherView()
}
