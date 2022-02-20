//
//  Constants.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 11.02.2022.
//

import Foundation

enum Constants {
    // MARK: - Keys
    static let userDefaultsIsLoggedInKey = "userIsLoggedIn"
    static let userDefaultsCurrentTemplatePathesKey = "currentTemplatePathes"
    
    // MARK: - Regular expressions
    static let passwordRegExp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#-])[A-Za-z\\dd$@$!%*?&#-]{8,}"
    static let emailRegExp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    // MARK: - Endpoints
    static let serverURL = getApiLink()
    static let apiKey = "&appid=" + getApiKey()
    
    // MARK: - Methods
    private static func getApiLink() -> String {
        return "https://api.openweathermap.org/data/2.5/weather"
    }
    
    //TODO hide api key
    private static func getApiKey() -> String {
        var nsDictionary: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
            
            if let value = nsDictionary?["WeatherApiKey"] as? String {
                return value
            } else {
                print("Config value couldn't be inferred")
            }
        } else {
            print("Config value couldn't be inferred")
        }
        return ""
    }
}
