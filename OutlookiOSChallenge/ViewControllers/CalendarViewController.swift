//
//  CalendarViewController.swift
//  OutlookiOSChallenge
//
//  Created by calvin on 2/4/2017.
//  Copyright © 2017年 me.calvinchankf. All rights reserved.
//

import UIKit
import CoreLocation

class CalendarViewController: UIViewController {
    
    // calendar view related
    @IBOutlet weak var calendarView: UICollectionView!
    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    var focusingIdx = 0
    var shouldAnimateChangingFocusingIdx = true
    
    // agenda view related
    @IBOutlet weak var agendaView: UITableView!
    var previousRow = 0
    
    // if calendar is shrinked
    var isCollectionViewShrink = true {
        didSet {
            self.todayButton.isHidden = !self.isCollectionViewShrink
        }
    }
    
    // data models
    let dateModel = DateModel.singleon
    let eventModel = EventModel()
    
    // a hashtable for events, avoid using array because of the lookup time
    var events = [String: [Event]]()
    
    // weather
    let weatherModel = WeatherModel()
    let locationManager = CLLocationManager()
    // a hashtable for events, avoid using array because of the lookup time
    var weathers = [String: Weather]()
    var locationFetched = false
    
    // today button
    @IBOutlet weak var todayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.calendarView.register(UINib(nibName: "DayCell", bundle: nil), forCellWithReuseIdentifier: "DayCell")
        self.agendaView.register(UINib(nibName: "AgendaHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "AgendaHeader")
        self.agendaView.register(UINib(nibName: "AgendaCell", bundle: nil), forCellReuseIdentifier: "AgendaCell")
        self.agendaView.register(UINib(nibName: "EmptyAgendaCell", bundle: nil), forCellReuseIdentifier: "EmptyAgendaCell")
        self.calendarViewHeight.constant = 2 * self.getCellLength()
        self.todayButton.layer.cornerRadius = 20
        
        // get event here
        self.events = self.eventModel.getStaticData()
        
        // get location
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let idx = self.dateModel.getIndexOfStartingDayForRendering()
        
        self.calendarView.scrollToItem(at: IndexPath(row: idx, section: 0), at: .top, animated: false)
        self.agendaView.scrollToRow(at: IndexPath(row: 0, section: idx), at: .top, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Action(s)
extension CalendarViewController {
    
    @IBAction func todayClicked(_ sender: Any) {
        // scroll to today
        let idx = self.dateModel.getIndexOfToday()
        self.shouldAnimateChangingFocusingIdx = false
        self.agendaView.scrollToRow(at: IndexPath(row: 0, section: idx), at: .top, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dateModel.calendarRange
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath as IndexPath) as? DayCell else {
            return UICollectionViewCell()
        }
        
        // date components for a cell
        guard let thatDate = self.dateModel.getComponentsBy(index: indexPath.item) else {
            return UICollectionViewCell()
        }
        
        // number of events
        guard let eventKey = self.dateModel.getDateFormatBy(index: indexPath.item) else {
            return UICollectionViewCell()
        }
        
        var numberOfEvents = 0
        var someoneBirthday = false
        if let eventsOnThatDay = self.events[eventKey] {
            numberOfEvents = eventsOnThatDay.count
            for x in eventsOnThatDay {
                // once anyone birthday, should display a birthday cake
                if x.birthday {
                    someoneBirthday = true
                    break
                }
            }
        }
        
        // display cell's content
        cell.display(thatDate, numberOfEvents, someoneBirthday)
        
        // display if the cell is focused
        if indexPath.item == self.focusingIdx {
            cell.setOnFocus(true)
        } else {
            cell.setOnFocus(false)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CalendarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // off-focus the previous focused cell
        if let previousSelectedCell = self.calendarView.cellForItem(at: IndexPath(row: self.focusingIdx, section: 0)) as? DayCell {
            previousSelectedCell.setOnFocus(false)
        }
        
        //  focus on the selected day
        if let selectedCell = self.calendarView.cellForItem(at: IndexPath(row: indexPath.item, section: 0)) as? DayCell {
            self.focusingIdx = indexPath.item
            selectedCell.setOnFocus(true)
            self.shouldAnimateChangingFocusingIdx = false
            self.agendaView.scrollToRow(at: IndexPath(row: 0, section: indexPath.item), at: .top, animated: true)
        }
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellLength = self.getCellLength()
        return CGSize(width: cellLength, height: cellLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // using integer as size to avoid unexpected space between cells
        // reason: minimumLineSpacingForSectionAt is just a minimum value but not exact value
        let offset = UIScreen.main.bounds.size.width - self.getCellLength() * 7
        return UIEdgeInsetsMake(0, offset/2, 0, offset/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

// MARK: - collection view cell helper(s)
extension CalendarViewController {
    func getCellLength() -> CGFloat {
        // using integer as size to avoid unexpected space between cells
        // reason: minimumLineSpacingForSectionAt is just a minimum value but not exact value
        return CGFloat(floor(UIScreen.main.bounds.size.width / 7))
    }
}

// MARK: - UITableViewDataSource
extension CalendarViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dateModel.calendarRange // previous 3 years + this week + next 3 years
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // depends on number of events on that day
        if let eventKey = self.dateModel.getDateFormatBy(index: section)
            , let eventsOnThatDay = self.events[eventKey]
        {
            return eventsOnThatDay.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let eventKey = self.dateModel.getDateFormatBy(index: indexPath.section)
            ,let eventsOnThatDay = self.events[eventKey]
        {
            if indexPath.item < eventsOnThatDay.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaCell") as?  AgendaCell else {
                    return EmptyAgendaCell()
                }
                cell.display(event: eventsOnThatDay[indexPath.item])
                return cell
            }
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyAgendaCell") as?  EmptyAgendaCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AgendaHeader") as? AgendaHeader else {
            return nil
        }
        
        guard let thatDate = self.dateModel.getComponentsBy(index: section) else {
            return nil
        }
        
        guard let weatherKey = self.dateModel.getDateFormatBy(index: section) else {
            return nil
        }
        
        var finalWeather: Weather? = nil
        if let weather = self.weathers[weatherKey] {
            finalWeather = weather
        }
        
        header.display(components: thatDate, weather: finalWeather)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: - UIScrollViewDelegate
// UITableViewDelegate and UIScrollViewDelegate are inherited from UIScrollViewDelegate
extension CalendarViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.agendaView {
            guard let idxPaths = self.agendaView.indexPathsForVisibleRows else {
                return
            }
            
            let visibleItems = self.calendarView.indexPathsForVisibleItems
            let firstVisibeSection = idxPaths[0].section
            
            guard visibleItems.count > 0 else {
                return
            }
            
            // if the focusing cell is not on the same row
            if visibleItems.count > 0 && self.previousRow != firstVisibeSection / 7 {
                self.previousRow = firstVisibeSection/7
                self.calendarView.scrollToItem(at: IndexPath(row: firstVisibeSection, section: 0), at: .top, animated: true)
            }
            
            // agendaView 'scroll' the focusing row
            if firstVisibeSection != self.focusingIdx && self.shouldAnimateChangingFocusingIdx {
                // off the previous focusing cell
                    
                // if scroll too fast, some cells would not be off-focus
                // (i see this bug in Outlook iOS app)
                // Detail:
                // According to the doc, cellForItem returns nil if indexPath is not visible / out of range
                // However, it sometimes return nil exceptionally
                // It seems that there is something wrong with the apple API
                // so for now, this is not a good idea to off-focus the previous focusing cell like this
                
//                let previousCell = self.calendarView.cellForItem(at: IndexPath(row: self.focusingIdx, section: 0)) as? DayCell
//                previousCell?.setOnFocus(false)
                
                // instead, off-focus all visibecells
                // this might not be a best way becasue it causes O(n) operations per on-focus
                // but it is a workaround for the apple's bug
                
                for x in self.calendarView.visibleCells {
                    (x as? DayCell)?.setOnFocus(false)
                }
                    
                // focus to the target day on calendar
                let cell = self.calendarView.cellForItem(at: IndexPath(row: firstVisibeSection, section: 0)) as? DayCell
                cell?.setOnFocus(true)
                
                // set navigation title
                if let thatDate = self.dateModel.getComponentsBy(index: firstVisibeSection)
                    ,let month = thatDate.month, let year = thatDate.year
                {
                    self.navigationItem.title = "\(self.dateModel.getMonthSymbolBy(month)) \(year)"
                }
                
                self.focusingIdx = firstVisibeSection
            }
            
            // animat shrink
            if !self.isCollectionViewShrink && scrollView.isTracking {
                self.isCollectionViewShrink = true
                
                self.calendarView.scrollToItem(at: IndexPath(row: firstVisibeSection, section: 0), at: .top, animated: true)
                
                self.calendarViewHeight.constant = 2 * self.getCellLength()
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                })
            }
            
        } else if scrollView == self.calendarView {
            
            // animat shrink
            if self.isCollectionViewShrink && scrollView.isTracking {
                self.isCollectionViewShrink = false
                self.calendarViewHeight.constant = 5 * self.getCellLength()
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // for both calendarView & agendaView,
        // we want them scroll to a top of a cell when scolling comes to a stop
        // it can be done by calculating a new target offset
        // and set it to the mutable targetContentOffset
        
        let oldTarget = targetContentOffset.pointee
        
        if scrollView == self.calendarView {
            let cellLength = self.getCellLength()
            
            let isScrollingUp = velocity.y < 0.0; // going up
            
            if isScrollingUp {
                let numberOfRows = floor(oldTarget.y / cellLength)
                let newTargetY = CGFloat(numberOfRows) * cellLength
                targetContentOffset.pointee = CGPoint(x: oldTarget.x, y: newTargetY)
            } else {
                let numberOfRows = floor(oldTarget.y / cellLength)
                let newTargetY = CGFloat(numberOfRows) * cellLength + cellLength
                targetContentOffset.pointee = CGPoint(x: oldTarget.x, y: newTargetY)
            }
        } else if scrollView == self.agendaView {
            guard let targetIdxPath = self.agendaView.indexPathForRow(at: oldTarget) else {
                return
            }
            let headerRect = self.agendaView.rectForHeader(inSection: targetIdxPath.section)
            let cellRect = self.agendaView.rectForRow(at: targetIdxPath)
            targetContentOffset.pointee = CGPoint(x: oldTarget.x, y: cellRect.origin.y - headerRect.size.height)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        // for any not shouldAnimateChangingFocusingIdx
        // we need to off-focus and on-focus the target cell upon scroll completion
        
        if scrollView == self.agendaView && !self.shouldAnimateChangingFocusingIdx {
            self.shouldAnimateChangingFocusingIdx = true
            guard let idxPaths = self.agendaView.indexPathsForVisibleRows else {
                return
            }
            let firstVisibeSection = idxPaths[0].section
            
            let previousCell = self.calendarView.cellForItem(at: IndexPath(row: self.focusingIdx, section: 0)) as? DayCell
            previousCell?.setOnFocus(false)
            
            let cell = self.calendarView.cellForItem(at: IndexPath(row: firstVisibeSection, section: 0)) as? DayCell
            cell?.setOnFocus(true)
            
            self.focusingIdx = firstVisibeSection
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension CalendarViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.last {
            let long = userLocation.coordinate.longitude;
            let lat = userLocation.coordinate.latitude;
            
            // fetch weather only for first time
            if !self.locationFetched {
                self.locationFetched = true
            } else {
                return
            }
            
            // use another queue apart from main queue to avoid blocking UI
            DispatchQueue.global(qos: .userInteractive).async(execute: {
                
                self.weatherModel.fetchForecast(lat: lat, long: long, success: { (result: [String : Weather]) in
                    
                    // UI compoentns are only be render on main queue
                    DispatchQueue.main.async(execute: { [weak self] in
                        if let weakself = self {
                            weakself.weathers = result
                            weakself.agendaView.reloadData()
                        }
                    })
                    
                    }, fail: {
                        // this location delegate always update while using
                        // so we can try again if previous call fails
                        self.locationFetched = false
                })
            })
            
        }
    }
    
}
