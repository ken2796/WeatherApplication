//
//  RequestEnums.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

typealias Parameters = [String: Any]

extension Parameters {
    static let serviceArrayOfParamsKey = "__array_of_params__"
}

extension Array where Element == [String: Any] {
    var asServiceParameter: Parameters {
        return [Parameters.serviceArrayOfParamsKey: self]
    }
}

enum RequestTask {
    case requestPlain
    case requestParameters(Parameters)
}

enum MultipartInput {
    case fileURL(URL)
    case data(Data, fileName: String)
    case value(Any)
}

enum ParametersEncoding {
    case url
    case json
    case multipart
}
