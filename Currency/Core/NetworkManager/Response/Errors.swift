//
//  Errors.swift
//  Currency
//
//  Created by gamal oraby on 31/05/2023.
//

import Foundation

public enum NetworkkError: Error {
  /// No internet
  case noInternet(error: Error)
  /// server failed, Host unreachable, …
  case serverUnreachable(error: Error)
  /// Invalid request, Fail to parse JSON, Unable to decode payload…
  case badServerResponse(error: Error)
  /// Response in 4xx-5xx range
  case http(httpURLResponse: HTTPURLResponse, data: Data?)
  /// Fail to parse response
  case parseError
  /// Other, unclassified error
  case otherError(error: Error)
  /// Request building has failed
  case requestBuildFail
  /// Upload manager has not been setup
  case uploadManagerIsNotSet
  /// Unknown
  case unknown
}
