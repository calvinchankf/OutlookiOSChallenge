//
//  DateModel.swift
//  OutlookiOSChallenge
//
//  Created by calvin on 2/4/2017.
//  Copyright © 2017年 me.calvinchankf. All rights reserved.
//

import Foundation

class DateModel {
    
    static let singleon = DateModel()
    
    let calendar: Calendar
    let calendarRadius = 52*3*7 // around 3 years of days
    let calendarRange: Int
    let startingDayForRendering = Date()
    
    private init() {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "en")
        self.calendar = cal
        // past 3 years + 1 week + next 3 years
        self.calendarRange = self.calendarRadius + 7 + self.calendarRadius
    }
    
    func getDateComponent(_ date: Date) -> DateComponents {
        // .year, .month, .weekday, .day are essentail in the result
        return self.calendar.dateComponents([.year, .month, .weekday, .day], from: date)
    }
    
    // since a user may open the app over midnight
    // we need to calculate the index by time time of buttonClicked being called
    func getIndexOfToday() -> Int {
        let c = self.getDateComponent(Date())
        // weeday start at 1 for sunday, but we need 1 for sunday, so we need to decrement it
        // unwrap .weekday directly because .weekday is guaranteed here from getDateComponent()
        let todayIdx = self.calendarRadius + c.weekday! - 1
        return todayIdx
    }
    
    // get index of starting day in the calendar range
    func getIndexOfStartingDayForRendering() -> Int {
        let c = self.getDateComponent(self.startingDayForRendering)
        let todayIdx = self.calendarRadius + c.weekday! - 1
        return todayIdx
    }
    
    // get date components by using the number of days from the starting day
    func getComponentsBy(index: Int) -> DateComponents? {
        
        // calculate the offset between the index and the starting day
        let diff = index - self.getIndexOfStartingDayForRendering()
        
        var dc = DateComponents()
        dc.day = diff
        
        if let thatDay = self.calendar.date(byAdding: dc, to: self.startingDayForRendering) {
            let thatDate = self.getDateComponent(thatDay)
            return thatDate
        }
        
        // if there is no date by adding the diff, just return nil
        // it is unlikely to happen but just in case
        return nil
    }
    
    // get date format by using the number of days from the starting day
    func getDateFormatBy(index: Int) -> String? {
        
        // calculate the offset between the index and the starting day
        let diff = index - self.getIndexOfStartingDayForRendering()
        
        var dc = DateComponents()
        dc.day = diff
        
        if let thatDay = self.calendar.date(byAdding: dc, to: self.startingDayForRendering) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let result = dateFormatter.string(from: thatDay)
            return result
        }
        
        // if there is no date by adding the diff, just return nil
        // it is unlikely to happen but just in case
        return nil
    }
    
    // get date format from timestamp
    func getDateFormatByTimestamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let result = dateFormatter.string(from: date)
        return result
    }
    
    // get monthsymbol by index of date components month
    func getMonthSymbolBy(_ month: Int) -> String {
        return self.calendar.shortMonthSymbols[month - 1]
    }
}
