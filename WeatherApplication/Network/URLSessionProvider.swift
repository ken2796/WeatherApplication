//
//  URLSessionProvider.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import Foundation

final class URLSessionProvider {
    static var shared = URLSessionProvider()

    private var session: URLSession

    let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        let standardDateFormatter = DateFormatter()
        standardDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        jsonDecoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            var date: Date?
            if let _date = standardDateFormatter.date(from: dateString) {
                date = _date
            } else if let _date = fullDateFormatter.date(from: dateString) {
                date = _date
            }

            guard let date = date else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            }
            return date
        })
        return jsonDecoder
    }()

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func request(service: ServiceProtocol) async throws -> EmptyObject {
        return try await request(EmptyObject.self, service: service)
    }

    func request<T: Decodable>(_ type: T.Type, service: ServiceProtocol, paginationControl: PaginationControl<T>? = nil) async throws -> T {
        let (data, response) = try await performTask(on: service)
        return try handleDataResponse(data: data, usingContainer: service.usesContainer, pagination: paginationControl, response: response)
    }

    private func performTask(on service: ServiceProtocol) async throws -> (Data, HTTPURLResponse) {
        let request = URLRequest(service: service)
        prettyPrint(.request(request), service: service)

        // Perform the network request using async/await
        let (data, response) = try await session.data(for: request)

        // Convert the URLResponse to HTTPURLResponse and handle possible failure
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIServiceError.noResponse
        }

        prettyPrint(.response(httpResponse, data), service: service)
        return (data, httpResponse)
    }

    private func handleDataResponse<T: Decodable>(data: Data, usingContainer: Bool, pagination: PaginationControl<T>?, response: HTTPURLResponse, customDecoder: ((Data) throws -> ServerResponse<T>)? = nil) throws -> T {
        switch response.statusCode {
        case 200 ... 299:
            if T.self == EmptyObject.self {
                return EmptyObject() as! T
            }

            if usingContainer {
                let model: ServerResponse<T>
                if let customDecoder = customDecoder {
                    model = try customDecoder(data)
                } else {
                    model = try jsonDecoder.decode(ServerResponse<T>.self, from: data)
                }

                guard let responseData = model.data else {
                    throw APIServiceError.noDataInContainer
                }

                pagination?.nextPageLink = model.pageInfo?.nextLink
                return responseData
            } else {
                if T.self == ImageData.self {
                    return ImageData(data: data) as! T
                }

                let model = try jsonDecoder.decode(T.self, from: data)
                return model
            }
        default:
            throw APIServiceError.unsupportedDataError
        }
    }
}

extension URLSessionProvider {
    private enum URLEvent {
        case request(URLRequest), response(URLResponse?, Data?)
    }

    private func prettyPrint(_ event: URLEvent, service: ServiceProtocol) {
        if let custom = service as? CustomService,
           !custom.showLogs {
            return
        }
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .long)
        if case let .request(request) = event {
            print("[📤 \(timestamp)] \(request.url?.absoluteString ?? "URL ❌")")

            if let header = request.allHTTPHeaderFields {
                print("🗒 Header: ", header.debugDescription)
            }

            if let body = request.httpBody,
               let str = String(data: body, encoding: .utf8) {
                print(str)
            }
        } else if case let .response(response, data) = event {
            guard let urlResponse = response as? HTTPURLResponse
            else { return print("Error || Invalid response") }

            let statusCode = urlResponse.statusCode
            let statusString = "\(statusCode) \(200 ... 299 ~= statusCode ? "" : "❌")"

            print("[📥 \(timestamp)]  [SERVICE: \(service)] \(urlResponse.url?.absoluteString ?? "URL ❌") \(statusString)")

            if let data = data,
               let stringData = String(data: data, encoding: .utf8) {
                print(stringData)
            }
        }
    }
}
