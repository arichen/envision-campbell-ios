//
//  EventViewController.swift
//  EnvisionCampbell
//
//  Created by Ari Chen on 1/6/16.
//  Copyright © 2016 Ari Chen. All rights reserved.
//

import UIKit
import MapKit
import EventKit
import ContentfulDeliveryAPI
import AirshipKit

class EventViewController: UIViewController {
    @IBOutlet weak var scrollView : UIScrollView!
    
    let containerView = UIView()
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var dateLabel = UILabel()
    var addressLabel = UILabel()
    var mapView = MKMapView()
    
    var eventData : CDAEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "plusButtonClicked:")
        self.navigationItem.rightBarButtonItem = plusButton
        
        initializeViews()
        initializeData()
    }
    
    func plusButtonClicked(sender: AnyObject) {
        let title = eventData?.fields["title"] as? String
        
        let alert = UIAlertController(title: "Add to Calendar", message: title, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.prepareAddEventToCalendar()
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func prepareAddEventToCalendar() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        if (status == EKAuthorizationStatus.Authorized) {
            self.addEventToCalendar()
        } else if (status == EKAuthorizationStatus.NotDetermined) {
            let eventStore = EKEventStore()
            eventStore.requestAccessToEntityType(EKEntityType.Event) { (granted: Bool, error: NSError?) -> Void in
                if (granted) {
                    self.addEventToCalendar()
                }
            }
        } else {
            // TODO: Remind user to change in Settings
        }
    }
    
    func addEventToCalendar() {
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        // title
        event.title = eventData?.fields["title"] as! String
        
        // notes
        event.notes = eventData?.fields["description"] as? String
        
        // event date
        event.startDate = eventData?.fields["startTime"] as! NSDate
        event.endDate = eventData?.fields["endTime"] as! NSDate
        
        // event location
        if #available(iOS 9.0, *) {
            if let location : CLLocationCoordinate2D = eventData?.CLLocationCoordinate2DFromFieldWithIdentifier("location") {
                let structuredLocation = EKStructuredLocation()
                structuredLocation.title = addressLabel.text!
                structuredLocation.geoLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                event.structuredLocation = structuredLocation
            }
        }
        
        do {
            try eventStore.saveEvent(event, span: EKSpan.ThisEvent, commit: true)
            
            let alert = UIAlertController(title: "Saved to Calendar!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            UAirship.shared().analytics.addEvent(UACustomEvent(name: "add_calendar"))
            
        } catch let error as NSError {
            print(error)
            
            let alert = UIAlertController(title: "Oops!", message: "Can't add to calendar", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func initializeViews() {
        let borderColor = UIColor(hexString: "DFDEE1")
        
        let metrics : [String : CGFloat] = [
            "margin": 20,
            "spacing": 12,
            "spacingLarge": 28,
            "width": 280,
            "height": 21,
            "containerMargin" : 5,
            "contentMargin" : 16,
        ]
        
        var views = [
            "containerView" : containerView,
            "titleLabel" : titleLabel,
            "descriptionLabel" : descriptionLabel,
        ]
        
        // containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = borderColor.CGColor
        scrollView.addSubview(containerView)
        
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-containerMargin-[containerView]-containerMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-containerMargin-[containerView(>=1)]-(>=containerMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        scrollView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1, constant: -2 * metrics["containerMargin"]!))
        
        
        // title & description
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFontOfSize(22)
        titleLabel.textColor = UIColor(hexString: "#444")
        containerView.addSubview(titleLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFontOfSize(15)
        descriptionLabel.textColor = UIColor(hexString: "#666")
        containerView.addSubview(descriptionLabel)
        
        var separatorView = UIView(frame: CGRectZero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = borderColor
        containerView.addSubview(separatorView)
        
        views["separatorView"] = separatorView
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(contentMargin)-[titleLabel]-(contentMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(contentMargin)-[descriptionLabel]-(contentMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[separatorView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(contentMargin)-[titleLabel(>=height)]-[descriptionLabel(>=height)]-(contentMargin)-[separatorView(1)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        views["lastView"] = separatorView
        
        
        // datetime
        var iconView = UIImageView(image: UIImage(named: "ic_clock"))
        iconView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconView)
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.numberOfLines = 0
        containerView.addSubview(dateLabel)
        
        separatorView = UIView(frame: CGRectZero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = borderColor
        containerView.addSubview(separatorView)
        
        views["iconView"] = iconView
        views["dateLabel"] = dateLabel
        views["separatorView"] = separatorView
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-contentMargin-[iconView(24)]-(spacing)-[dateLabel]-contentMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[separatorView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[iconView(24)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraint(NSLayoutConstraint(item: iconView, attribute: .CenterY, relatedBy: .Equal, toItem: dateLabel, attribute: .CenterY, multiplier: 1, constant: 0))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[lastView]-(contentMargin)-[dateLabel(>=21)]-(contentMargin)-[separatorView(1)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        views["lastView"] = separatorView
        
        
        // address
        iconView = UIImageView(image: UIImage(named: "ic_location"))
        iconView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconView)
        
        addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.numberOfLines = 0
        containerView.addSubview(addressLabel)
        
        separatorView = UIView(frame: CGRectZero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = borderColor
        containerView.addSubview(separatorView)
        
        views["iconView"] = iconView
        views["addressLabel"] = addressLabel
        views["separatorView"] = separatorView
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-contentMargin-[iconView(24)]-[addressLabel]-contentMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[separatorView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[iconView(24)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraint(NSLayoutConstraint(item: iconView, attribute: .CenterY, relatedBy: .Equal, toItem: addressLabel, attribute: .CenterY, multiplier: 1, constant: 0))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[lastView]-(contentMargin)-[addressLabel(>=21)]-(contentMargin)-[separatorView(1)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        views["lastView"] = separatorView
        
        // map
        mapView = MKMapView(frame: CGRectZero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.borderWidth = 2
        mapView.layer.borderColor = UIColor.whiteColor().CGColor
        containerView.addSubview(mapView)
        
        views["mapView"] = mapView
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[mapView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[lastView]-[mapView(200)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
    }
    
    func initializeData() {
        let labelAttrs = [
            NSForegroundColorAttributeName : UIColor(hexString: "666"),
            NSFontAttributeName : UIFont.systemFontOfSize(14)
        ]
        let contentAttrs = [
            NSForegroundColorAttributeName : UIColor(hexString: "444"),
            NSFontAttributeName : UIFont.systemFontOfSize(16)
        ]
        
        // title
        titleLabel.text = eventData?.fields["title"] as? String
        
        // description
        if let description = eventData?.fields["description"] as? String {
            descriptionLabel.attributedText = NSAttributedString(string: description, attributes: labelAttrs)
        }
        
        // datetime
        let startDate = eventData?.fields["startTime"] as! NSDate
        let endDate = eventData?.fields["endTime"] as! NSDate
        
        let df = NSDateFormatter()
        df.dateFormat = "MMM dd yyyy, h:mm a"
        df.AMSymbol = "AM"
        df.PMSymbol = "PM"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacingBefore = 5
        
        let startTimeLabel = NSAttributedString(string: "Start Time\n", attributes: labelAttrs)
        let startTime = NSAttributedString(string: df.stringFromDate(startDate), attributes: contentAttrs)
        let endTimeLabel = NSMutableAttributedString(string: "\nEnd Time\n", attributes: labelAttrs)
        endTimeLabel.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, endTimeLabel.string.characters.count))
        let endTime = NSAttributedString(string: df.stringFromDate(endDate), attributes: contentAttrs)
        
        var text = NSMutableAttributedString(attributedString: startTimeLabel)
        text.appendAttributedString(startTime)
        text.appendAttributedString(endTimeLabel)
        text.appendAttributedString(endTime)
        
        dateLabel.attributedText = text
        
        // address
        if let address = eventData?.fields["address"] as? String {
            text = NSMutableAttributedString(string: "Address\n", attributes: labelAttrs)
            text.appendAttributedString(NSAttributedString(string: address, attributes: contentAttrs))
            
            addressLabel.attributedText = text
        }
        
        // location
        if let location : CLLocationCoordinate2D = eventData?.CLLocationCoordinate2DFromFieldWithIdentifier("location") {
            let regionRadius : CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2, regionRadius * 2)
            
            mapView.setCenterCoordinate(location, animated: true)
            mapView.setRegion(coordinateRegion, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
        }
    }
}
