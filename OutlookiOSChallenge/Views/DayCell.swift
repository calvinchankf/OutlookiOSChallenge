//
//  DayCell.swift
//  OutlookiOSChallenge
//
//  Created by calvin on 2/4/2017.
//  Copyright © 2017年 me.calvinchankf. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {

    
    @IBOutlet weak var focusedBackgroundView: UIView!
    @IBOutlet weak var birthdayCakeImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var numberOfEventsLabel: UILabel!
    
    var someoneBirthday = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.birthdayCakeImageView.image = self.birthdayCakeImageView.image!.withRenderingMode(.alwaysTemplate)
        self.birthdayCakeImageView.tintColor = UIColor.lightGray
    }
    
    func display(_ components: DateComponents, _ numberOfEvents: Int, _ someoneBirthday: Bool) {
        let today = DateModel.singleon.getDateComponent(Date())
        if let thisYear = today.year
            , let year = components.year, let month = components.month, let day = components.day
        {
            //
            self.backgroundColor = month % 2 == 0 ? UIColor.outlookUltraLight : UIColor.white
            
            //
            if day == 1 {
                let monthSymbol = DateModel.singleon.getMonthSymbolBy(month)
                if year != thisYear {
                    self.dayLabel.text = "\(monthSymbol) \(day) \(year)"
                } else {
                    self.dayLabel.text = "\(monthSymbol) \(day)"
                }
            } else {
                self.dayLabel.text = "\(day)"
            }
            
            // 
            self.birthdayCakeImageView.isHidden = !someoneBirthday
            self.someoneBirthday = someoneBirthday
            
            //
            if numberOfEvents > 0 {
                self.numberOfEventsLabel.isHidden = false
                self.numberOfEventsLabel.text = "\(numberOfEvents)"
            } else {
                self.numberOfEventsLabel.isHidden = true
            }
        }
    }

    func setOnFocus(_ isFocus: Bool) {
        if isFocus {
            self.focusedBackgroundView.layer.cornerRadius = self.frame.size.height / 2 - 5
            self.focusedBackgroundView.backgroundColor = UIColor.outlookBlue
            self.dayLabel.textColor = UIColor.white
            self.numberOfEventsLabel.textColor = UIColor.outlookBlue
            self.birthdayCakeImageView.isHidden = true
        } else {
            self.focusedBackgroundView.backgroundColor = UIColor.clear
            self.dayLabel.textColor = UIColor.lightGray
            self.numberOfEventsLabel.textColor = UIColor.lightGray
            self.birthdayCakeImageView.isHidden = !self.someoneBirthday
        }
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.backgroundColor = UIColor.clear
//        self.numberOfEventsLabel.isHidden = true
//    }
}
