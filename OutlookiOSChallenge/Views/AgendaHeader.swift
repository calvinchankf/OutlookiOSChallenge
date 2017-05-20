//
//  AgendaHeader.swift
//  OutlookiOSChallenge
//
//  Created by calvin on 3/4/2017.
//  Copyright © 2017年 me.calvinchankf. All rights reserved.
//

import UIKit

class AgendaHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func awakeFromNib() {
        self.contentView.backgroundColor = UIColor.outlookUltraLight
    }
    
    func display(components: DateComponents, weather: Weather? = nil) {
        if let year = components.year, let month = components.month, let day = components.day {
            let monthSymbol = DateModel.singleon.getMonthSymbolBy(month)
            self.dateLabel.text = "\(monthSymbol) \(day) \(year)"
        }
        if let weather = weather, let temperatue = weather.temperatue, let icon = weather.icon {
            var weatherString = ""
            if icon.range(of: "clear") != nil {
                weatherString += "☀️"
            } else if icon.range(of: "rain") != nil {
               weatherString += "🌧"
            } else if icon.range(of: "snow") != nil {
                weatherString += "❄️"
            } else if icon.range(of: "fog") != nil {
                weatherString += "🌫"
            } else if icon.range(of: "cloudy") != nil {
                weatherString += "⛅️"
            }
            weatherString += "\(temperatue)℉"
            self.weatherLabel.text = weatherString
            self.weatherLabel.isHidden = false
        } else {
            self.weatherLabel.isHidden = true
        }
    }
}
