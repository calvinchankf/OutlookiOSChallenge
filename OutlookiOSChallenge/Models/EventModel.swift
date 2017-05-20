//
//  EventModel.swift
//  OutlookiOSChallenge
//
//  Created by calvin on 2/4/2017.
//  Copyright © 2017年 me.calvinchankf. All rights reserved.
//

import Foundation
import UIKit

class Event {
    
    // mock data
    // use handy data type for demo only
    
    let title: String
    let startTime: String
    let duration: String
    let location: String
    let people: [String]
    let color: UIColor
    let birthday: Bool
    
    init(title: String, start: String, duration: String, location: String, people: [String], color: UIColor, birthday: Bool = false) {
        self.title = title
        self.startTime = start
        self.duration = duration
        self.location = location
        self.people = people
        self.color = color
        self.birthday = birthday
    }
}

class EventModel {
    
    // static data
    // Using a hashtable to speed up the lookup time, it is more handy for demo
    func getStaticData() -> [String: [Event]] {
        
        let myBirthday = [
            Event(title: "Calvin's Birthday", start: "12:00 AM", duration: "24h", location: "Anywhere", people: ["me"], color: UIColor.red, birthday: true)
        ]
        
        let a = [
            Event(title: "Super big meeting, very important, all people must attend!!!!", start: "1pm", duration: "3h", location: "Central, Hong Kong", people: ["p1","p2","p3"], color: UIColor.green),
            Event(title: "Small meeting", start: "2pm 30m", duration: "1h", location: "Sha Tin, Hong Kong", people: ["p4","p5"], color: UIColor.yellow),
            Event(title: "Dinner", start: "7pm", duration: "2h", location: "Sai Kung, Hong Kong", people: ["p3"], color: UIColor.purple)
            ]
        
        let b = [
            Event(title: "Something important", start: "1am", duration: "30m", location: "Tue Mum, Hong Kong", people: ["p1","p2"], color: UIColor.orange),
            Event(title: "college reunion", start: "7pm", duration: "4h", location: "Hong Kong", people: ["p1","p2","p3"], color: UIColor.brown),
            ]
        
        return [
            "03/04/2017": myBirthday,
            "05/04/2017": a,
            "11/04/2017": b,
            "20/04/2017": a,
            "26/04/2017": b,
            "01/05/2017": a,
            "09/05/2017": b,
        ]
    }
}
