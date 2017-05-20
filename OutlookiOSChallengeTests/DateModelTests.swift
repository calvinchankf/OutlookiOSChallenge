//
//  DateModelTests.swift
//  OutlookiOSChallenge
//
//  Created by calvin on 3/4/2017.
//  Copyright © 2017年 me.calvinchankf. All rights reserved.
//

import XCTest

class DateModelTests: XCTestCase {
    
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
    
    // test if getComponentsBy(index: Int) return probably for ranges
    func testGetComponentsByIndex() {
        
        // mock model
        let model = DateModel.singleon
        let calendarRadius = 52*3*7
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en")
        
        // within range: index = 0
        let index = 0
        
        let c = calendar.dateComponents([.year, .month, .weekday, .day], from: Date())
        let dayIdx = calendarRadius + c.weekday! - 1
        let diff = index - dayIdx
        
        var dc = DateComponents()
        dc.day = diff
        
        if let thatDay = calendar.date(byAdding: dc, to: Date()) {
            let thatDate = calendar.dateComponents([.year, .month, .weekday, .day], from: thatDay)
            
            // compare the getComponentsByIndex with mock data(within range)
            let testDate = model.getComponentsBy(index: index)
            XCTAssert(testDate == thatDate)
        }
        
        // out of range: index = - 1
        let index1 = -1
        let c1 = calendar.dateComponents([.year, .month, .weekday, .day], from: Date())
        let dayIdx1 = calendarRadius + c1.weekday! - 1
        let diff1 = index1 - dayIdx1
        
        var dc1 = DateComponents()
        dc1.day = diff1
        
        if let thatDay1 = calendar.date(byAdding: dc1, to: Date()) {
            let thatDate = calendar.dateComponents([.year, .month, .weekday, .day], from: thatDay1)
            
            // compare the getComponentsBy with mock data even if the index is out of calendarRange
            let testDate = model.getComponentsBy(index: index1)
            XCTAssert(testDate == thatDate)
        }
        
        // out of range: index = 1 + calendarRange
        let index2 = 1 + calendarRadius * 2 + 7
        let c2 = calendar.dateComponents([.year, .month, .weekday, .day], from: Date())
        let dayIdx2 = calendarRadius + c2.weekday! - 1
        let diff2 = index2 - dayIdx2
        
        var dc2 = DateComponents()
        dc2.day = diff2
        
        if let thatDay2 = calendar.date(byAdding: dc2, to: Date()) {
            let thatDate = calendar.dateComponents([.year, .month, .weekday, .day], from: thatDay2)
            
            // compare the getComponentsBy with mock data even if the index is out of calendarRange
            let testDate = model.getComponentsBy(index: index2)
            XCTAssert(testDate == thatDate)
        }
    }
    
    // getDateFormatBy(index: Int)
    func testGetDateFormatByIndex() {
        
        // mock model
        let model = DateModel.singleon
        let calendarRadius = 52*3*7
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en")
        
        // within range: index = 0
        let index = 0
        
        let c = calendar.dateComponents([.year, .month, .weekday, .day], from: Date())
        let dayIdx = calendarRadius + c.weekday! - 1
        let diff = index - dayIdx
        
        var dc = DateComponents()
        dc.day = diff
        
        if let thatDay = calendar.date(byAdding: dc, to: Date()) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let result = dateFormatter.string(from: thatDay)
            
            // compare the getDateFormatBy with mock data(within range)
            let testDate = model.getDateFormatBy(index: index)
            XCTAssert(testDate == result)
        }
        
        // out of range: index = - 1
        let index1 = -1
        let c1 = calendar.dateComponents([.year, .month, .weekday, .day], from: Date())
        let dayIdx1 = calendarRadius + c1.weekday! - 1
        let diff1 = index1 - dayIdx1
        
        var dc1 = DateComponents()
        dc1.day = diff1
        
        if let thatDay1 = calendar.date(byAdding: dc1, to: Date()) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let result = dateFormatter.string(from: thatDay1)
            
            // compare the getDateFormatBy with mock data even if the index is out of calendarRange
            let testDate = model.getDateFormatBy(index: index1)
            XCTAssert(testDate == result)
        }
        
        // out of range: index = 1 + calendarRange
        let index2 = 1 + calendarRadius * 2 + 7
        let c2 = calendar.dateComponents([.year, .month, .weekday, .day], from: Date())
        let dayIdx2 = calendarRadius + c2.weekday! - 1
        let diff2 = index2 - dayIdx2
        
        var dc2 = DateComponents()
        dc2.day = diff2
        
        if let thatDay2 = calendar.date(byAdding: dc2, to: Date()) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let result = dateFormatter.string(from: thatDay2)
            
            // compare the getDateFormatBy with mock data even if the index is out of calendarRange
            let testDate = model.getDateFormatBy(index: index2)
            XCTAssert(testDate == result)
        }
    }
}
