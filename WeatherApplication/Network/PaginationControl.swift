//
//  PaginationControl.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import Foundation

// This Pagination Control is for the future Reference
class PaginationControl<T: Decodable> {
    private var service: ServiceProtocol
    var nextPageLink: String?

    init(service: ServiceProtocol) {
        self.service = service
    }

    func getNextPage() async throws -> T {
        var serviceParams: Parameters?
        if case let .requestParameters(params) = service.task {
            serviceParams = params
        }

        if let nextPageLink = nextPageLink, let url = URL(string: nextPageLink),
           let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var linkParams = urlComponents.queryItems

            serviceParams?.forEach { linkParams?.append(.init(name: $0.key, value: "\($0.value)")) }

            var requestParams: Parameters = [:]
            linkParams?.forEach { requestParams[$0.name] = $0.value }

            let newServiceTask: RequestTask = .requestParameters(requestParams)

            self.nextPageLink = nil

            // Create new service for the next page
            let nextPageService = CustomService(
                path: service.path,
                method: service.method,
                task: newServiceTask,
                needsAuthentication: service.needsAuthentication,
                usesContainer: service.usesContainer,
                parametersEncoding: .url
            )

            // Await the request using the new service
            let result = try await URLSessionProvider.shared.request(T.self, service: nextPageService, paginationControl: self)
            return result
        } else {
            print("ERROR || Next page link is empty or invalid")
            throw APIServiceError.noData
        }
    }
}
