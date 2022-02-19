//
//  NetworkService.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 10.02.2022.
//

import Foundation
import Alamofire
import Combine

typealias UnitedNetworkServiceProtocol = NetworkServiceProtocol & PublishableNetworkServiceProtocol

protocol NetworkServiceProtocol {
    func request<T: Decodable>(domain: String,
                               endpoint: Endpoint,
                               headers: [String : String]?,
                               parameters: Parameters?,
                               encoding: ParameterEncoding?,
                               completion: @escaping (Result<T, AppError>) -> Void)
    
    func request<T: Decodable, U: Encodable>(domain: String,
                                             endpoint: Endpoint,
                                             headers: [String : String]?,
                                             parameters: U?,
                                             encoder: ParameterEncoder?,
                                             completion: @escaping (Result<T, AppError>) -> Void)
}

protocol PublishableNetworkServiceProtocol: AnyObject {
    func request<T: Decodable>(domain: String,
                               endpoint: Endpoint,
                               headers: [String : String]?,
                               parameters: Parameters?,
                               encoding: ParameterEncoding?) -> AnyPublisher<T, AppError>
    
    func request<T: Decodable, U: Encodable>(domain: String,
                                             endpoint: Endpoint,
                                             headers: [String : String]?,
                                             parameters: U?,
                                             encoder: ParameterEncoder?) -> AnyPublisher<T, AppError>
    
    func request(url: URL) -> AnyPublisher<Data, AppError>
}

final class NetworkService {
    private let authTokenStorage: AuthTokenStorageProtocol = AuthTokenStorage()
    private let session = Session(configuration: URLSessionConfiguration.af.default, eventMonitors: [AlamofireLogger()])
    static let shared = NetworkService()
    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    private init() {
        
    }
    
    private var getAuthToken: String? {
        if let token = try? authTokenStorage.getToken() {
            return token
        } else {
            return nil
        }
    }
    
    //MARK: - Private
    private func makeHttpHeadersWithAuth(form headers: [String : String]?) -> HTTPHeaders {
        let httpHeaders: HTTPHeaders = HTTPHeaders(headers ?? [:])
        
//        if let token = getAuthToken {
//            httpHeaders.add(name: "Authorization",
//                            value: token)
//
//            httpHeaders.add(name: "Accept",
//                            value: "application/json")
//        }
        
        return httpHeaders
    }
    
    //MARK: - Internal
    func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening(
            onUpdatePerforming: { status in
                switch status {
                case .notReachable: printIfDebug("The network is not reachable")
                case .unknown: printIfDebug("It is unknown whether the network is reachable")
                case .reachable(.ethernetOrWiFi): printIfDebug("The network is reachable over the WiFi connection")
                case .reachable(.cellular): printIfDebug("The network is reachable over the cellular connection")
                }
            }
        )
    }
    
}

extension NetworkService: NetworkServiceProtocol {
    func request<T>(domain: String,
                    endpoint: Endpoint,
                    headers: [String : String]?,
                    parameters: Parameters?,
                    encoding: ParameterEncoding?,
                    completion: @escaping (Result<T, AppError>) -> Void) where T : Decodable {
        session.request(domain + endpoint.path,
                        method: endpoint.method,
                        parameters: parameters,
                        encoding: encoding ?? URLEncoding.default,
                        headers: makeHttpHeadersWithAuth(form: headers))
            .validate()
            .responseDecodable(of: T.self,
                               emptyResponseCodes: [200],
                               completionHandler: { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(AppError.ServerError(error.responseCode)))
                }
            })
    }
    
    func request<T, U>(domain: String,
                       endpoint: Endpoint,
                       headers: [String : String]?,
                       parameters: U?,
                       encoder: ParameterEncoder?,
                       completion: @escaping (Result<T, AppError>) -> Void) where T : Decodable, U : Encodable {
        
        session.request(domain + endpoint.path,
                        method: endpoint.method,
                        parameters: parameters,
                        encoder: encoder ?? JSONParameterEncoder.default,
                        headers: makeHttpHeadersWithAuth(form: headers))
            .validate()
            .responseDecodable(of: T.self,
                               emptyResponseCodes: [200], completionHandler: { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(AppError.ServerError(error.responseCode)))
                }
            })
    }
}

extension NetworkService: PublishableNetworkServiceProtocol {
    func request<T>(domain: String, endpoint: Endpoint, headers: [String : String]?, parameters: Parameters?, encoding: ParameterEncoding?) -> AnyPublisher<T, AppError> where T : Decodable {
        return session.request(domain + endpoint.path,
                               method: endpoint.method,
                               parameters: parameters,
                               encoding: encoding ?? URLEncoding.default,
                               headers: makeHttpHeadersWithAuth(form: headers))
            .validate()
            .publishDecodable(type: T.self, emptyResponseCodes: [200])
            .value()
            .mapError { error in
                return AppError.ServerError(error.responseCode)
            }
            .eraseToAnyPublisher()
    }
    
    func request<T, U>(domain: String, endpoint: Endpoint, headers: [String : String]?, parameters: U?, encoder: ParameterEncoder?) -> AnyPublisher<T, AppError> where T : Decodable, U : Encodable {
        return session.request(domain + endpoint.path,
                               method: endpoint.method,
                               parameters: parameters,
                               encoder: encoder ?? JSONParameterEncoder.default,
                               headers: makeHttpHeadersWithAuth(form: headers))
            .validate()
            .publishDecodable(type: T.self, emptyResponseCodes: [200])
            .value()
            .mapError { error in
                AppError.ServerError(error.responseCode)
            }
            .eraseToAnyPublisher()
    }
    
    func request(url: URL) -> AnyPublisher<Data, AppError> {
        let urlRequest = URLRequest(url: url)
        
        return session.request(urlRequest)
            .validate()
            .publishData()
            .value()
            .mapError { error in
                AppError.ServerError(error.responseCode)
            }
            .eraseToAnyPublisher()
    }
}

//MARK: - ParameterEncoding
extension Data: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = self
        
        return request
    }
}
