//
//  Errors.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 10.02.2022.
//

import Foundation
import Alamofire

enum AppError: Error {
    case UnknownError
    case NoInternetError
    case WrongResponseFormat
    case EmptyResponse
    case ImageNotFound
    case WrongData
    case InternetConnectionRequired
    case ServerError(Int?)
    case DataBaseError(StorageError)
    
    public var error: String {
        switch self {
        case .UnknownError: return "Unknown error"
        case .NoInternetError: return "No internet connection"
        case .WrongResponseFormat: return "Wrong response"
        case .EmptyResponse: return "Empty response"
        case .ImageNotFound: return "Image not found"
        case .WrongData: return "Wrong data"
        case .InternetConnectionRequired: return "An internet connection is required"
        case .ServerError(let errorCode):
            switch errorCode {
            case 0: return "Unknown error"
            case 401: return "Client Error"
            case 503: return "Service unavailable"
            default: return AppError.UnknownError.error
            }
        case .DataBaseError(let errorType):
            switch errorType {
            case .readError(_): return "Data base read error"
            case .saveError(_): return "Data base save error"
            case .deleteError(_): return "Data base delete error"
            case .emptyResponseError: return "Data base empty response error"
            case .conversionError: return "Data base conversion error"
            case .unhandledError(let message): return "\(message) error"
            }
        }
    }
}

enum StorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
    case emptyResponseError
    case conversionError
    case unhandledError(message: String)
}
