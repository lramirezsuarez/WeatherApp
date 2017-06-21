//
//  WeatherFacade.swift
//  WeatherApp
//
//  Created by Luis Ramirez on 6/20/17.
//  Copyright © 2017 Lucho. All rights reserved.
//

import Foundation

struct WeatherFacade {
    static let baseURL = "http://www.weather-forecast.com/locations/"
    static let endURL = "/forecasts/latest"
    static var message = ""
    
    static func retrieveWeather(city : String, completion : @escaping (String) -> Void) {
        let url = baseURL + city + endURL
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            data, response, error in
            
            if(error != nil) {
                print("There was an error.")
            } else {
                if let recievedData = data {
                    let dataString = NSString(data: recievedData, encoding: String.Encoding.utf8.rawValue)
                    
                    var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if contentArray.count > 1 {
                            
                            stringSeparator = "</span>"
                            
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            
                            if newContentArray.count > 1 {
                                self.message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "º")
                            }
                        }
                    }
                }
            }
            
            if self.message == "" {
                self.message = "The Weather in \(city) has not been found. Please try again."
            }
            
            completion(message)
        }
        
        
        
        task.resume()
    }
}
