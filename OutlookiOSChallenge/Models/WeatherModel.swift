//
//  WeatherModel.swift
//  OutlookiOSChallenge
//
//  Created by calvin on 3/4/2017.
//  Copyright © 2017年 me.calvinchankf. All rights reserved.
//

import Foundation

class Weather {
    
    let timestamp: Int? // for transforming a array to a hashtable
    let icon: String?
    let temperatue: Int?
    
    init(timestamp: Int?, icon: String?, temperatue: Int?) {
        self.timestamp = timestamp
        self.icon = icon
        self.temperatue = temperatue
    }
    
    init(data: [String: AnyObject]) {
        self.timestamp = data["time"] as? Int ?? nil
        self.icon = data["icon"] as? String ?? ""
        let min = data["temperatureMin"] as? Int ?? nil
        let max = data["temperatureMax"] as? Int ?? nil
        if let min = min, let max = max {
            self.temperatue = (max + min) / 2
        } else {
            self.temperatue = nil
        }
    }
}

class WeatherModel {
    
    init() {
        
    }
    
    // fetch weather from Forecast.io
    func fetchForecast(lat: Double, long: Double
        , success: @escaping ([String: Weather]) -> ()
        , fail: @escaping () -> ())
    {
        let urlString = URL(string: "https://api.darksky.net/forecast/ba388fbd69ca309b7da5c2c7809749b1/\(lat),\(long)?exclude=currently,hourly,alerts,flags,minutely")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    return fail()
                }
                
                guard let data = data else {
                    return fail()
                }
                
                if let days = self.weatherParser(data) {
                    var result = [String: Weather]()
                    for day in days {
                        if let time = day.timestamp {
                            let key = DateModel.singleon.getDateFormatByTimestamp(time)
                            result[key] = day
                        }
                    }
                    success(result)
                } else {
                    fail()
                }
            }
            task.resume()
        }
    }
    
    // parse Data to an array of Weather
    func weatherParser(_ data: Data) -> [Weather]? {
        var result = [Weather]()
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            guard let daily = json?["daily"] as? [String: Any] else {
                return nil
            }
            guard let data = daily["data"] as? [[String: AnyObject]] else {
                return nil
            }
            for day in data {
                result.append(Weather(data: day))
            }
        }
        
        return result
    }
}
