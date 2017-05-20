//
//  WeatherModelTests.swift
//  OutlookiOSChallenge
//
//  Created by calvin on 4/4/2017.
//  Copyright © 2017年 me.calvinchankf. All rights reserved.
//

import XCTest

class WeatherModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // test if weatherParser(_ data: Data) if perform probably for cases
    // e.g. some fields are missing
    func testWeatherParser() {
        
        let model = WeatherModel()
        
        // normal data
        do {
            let supposedResut = [
                Weather(timestamp: 0, icon: "partly-cloudy-day", temperatue: 2),
                Weather(timestamp: 1, icon: "partly-cloudy-day", temperatue: 3),
                Weather(timestamp: 2, icon: "partly-cloudy-day", temperatue: 4),
            ]
            if let file = Bundle.main.url(forResource: "normal", withExtension: "json") {
                let data = try Data(contentsOf: file)
                
                if let days = model.weatherParser(data) {
                    for (idx, day) in days.enumerated() {
                        XCTAssert(supposedResut[idx].timestamp == day.timestamp)
                        XCTAssert(supposedResut[idx].icon == day.icon)
                        XCTAssert(supposedResut[idx].temperatue == day.temperatue)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // no timestamp
        do {
            let supposedResut = [
                Weather(timestamp: nil, icon: "partly-cloudy-day", temperatue: 2),
                Weather(timestamp: nil, icon: "partly-cloudy-day", temperatue: 3),
                Weather(timestamp: nil, icon: "partly-cloudy-day", temperatue: 4),
                ]
            if let file = Bundle.main.url(forResource: "noTimestamp", withExtension: "json") {
                let data = try Data(contentsOf: file)
                
                if let days = model.weatherParser(data) {
                    for (idx, day) in days.enumerated() {
                        XCTAssert(supposedResut[idx].timestamp == day.timestamp)
                        XCTAssert(supposedResut[idx].icon == day.icon)
                        XCTAssert(supposedResut[idx].temperatue == day.temperatue)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // no icon
        do {
            let supposedResut = [
                Weather(timestamp: 0, icon: nil, temperatue: 2),
                Weather(timestamp: 1, icon: nil, temperatue: 3),
                Weather(timestamp: 2, icon: nil, temperatue: 4),
                ]
            if let file = Bundle.main.url(forResource: "noIcon", withExtension: "json") {
                let data = try Data(contentsOf: file)
                
                if let days = model.weatherParser(data) {
                    for (idx, day) in days.enumerated() {
                        XCTAssert(supposedResut[idx].timestamp == day.timestamp)
                        XCTAssert(supposedResut[idx].icon == day.icon)
                        XCTAssert(supposedResut[idx].temperatue == day.temperatue)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // no temperature
        do {
            let supposedResut = [
                Weather(timestamp: 0, icon: "partly-cloudy-day", temperatue: nil),
                Weather(timestamp: 1, icon: "partly-cloudy-day", temperatue: nil),
                Weather(timestamp: 2, icon: "partly-cloudy-day", temperatue: nil),
                ]
            if let file = Bundle.main.url(forResource: "noTemperature", withExtension: "json") {
                let data = try Data(contentsOf: file)
                
                if let days = model.weatherParser(data) {
                    for (idx, day) in days.enumerated() {
                        XCTAssert(supposedResut[idx].timestamp == day.timestamp)
                        XCTAssert(supposedResut[idx].icon == day.icon)
                        XCTAssert(supposedResut[idx].temperatue == day.temperatue)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // no data
        do {
            if let file = Bundle.main.url(forResource: "noData", withExtension: "json") {
                let data = try Data(contentsOf: file)
                
                let days = model.weatherParser(data)
                XCTAssert(days == nil)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // no daily
        do {
            if let file = Bundle.main.url(forResource: "noDaily", withExtension: "json") {
                let data = try Data(contentsOf: file)
                
                let days = model.weatherParser(data)
                XCTAssert(days == nil)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
