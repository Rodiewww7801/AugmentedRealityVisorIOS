//
//  AlamofireLogger.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 11.02.2022.
//

import Foundation
import Alamofire
import Accessibility

final class AlamofireLogger: EventMonitor {
    func requestDidResume(request: Request) {
        let body = request.request.flatMap {
            $0.httpBody.map {
                String(decoding: $0, as: UTF8.self)
            }
        } ?? "None"
        
        let message  = """
        Request Started: \(request)
        Request Body: \(body)
        """
        
        NSLog(message)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: AFDataResponse<Value>) {
        NSLog("Response received: \(response.debugDescription)")
    }
}
