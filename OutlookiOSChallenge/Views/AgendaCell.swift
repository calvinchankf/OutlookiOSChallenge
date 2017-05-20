//
//  AgendaCell.swift
//  OutlookiOSChallenge
//
//  Created by calvin on 2/4/2017.
//  Copyright © 2017年 me.calvinchankf. All rights reserved.
//

import UIKit

class AgendaCell: UITableViewCell {

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pinImageView: UIImageView!
    
    // Actaully, some feilds is optional in real situation
    // I usually add views programmically because there might be no people and/or no location
    // so below implementation is just a hacky way for demo
    @IBOutlet weak var firstPersonImgView: UIImageView!
    @IBOutlet weak var secondPersonImgView: UIImageView!
    @IBOutlet weak var thirdPersonImgView: UIImageView!
    @IBOutlet weak var pinImgView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.colorView.layer.cornerRadius = 5
        self.firstPersonImgView.layer.cornerRadius = 15
        self.secondPersonImgView.layer.cornerRadius = 15
        self.thirdPersonImgView.layer.cornerRadius = 15
        self.pinImageView.image = pinImageView.image!.withRenderingMode(.alwaysTemplate)
        self.pinImageView.tintColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func display(event: Event) {
        self.startTimeLabel.text = event.startTime
        self.durationLabel.text = event.duration
        self.colorView.backgroundColor = event.color
        self.titleLabel.text = event.title
        
        if event.people.count > 0 {
            self.firstPersonImgView.image = UIImage(named: event.people[0])
        }
        
        if event.people.count > 1 {
            self.secondPersonImgView.image = UIImage(named: event.people[1])
        }
        
        if event.people.count > 2 {
            self.thirdPersonImgView.image = UIImage(named: event.people[2])
        }
        
        self.locationLabel.text = event.location
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.firstPersonImgView.image = nil
        self.secondPersonImgView.image = nil
        self.thirdPersonImgView.image = nil
    }
}
