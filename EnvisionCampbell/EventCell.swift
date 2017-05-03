//
//  DocumentCell.swift
//  EnvisionCampbell
//
//  Created by Ari Chen on 1/20/16.
//  Copyright © 2016 Ari Chen. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    static let identifier : String = "eventCell"
    static let cellHeight : CGFloat = 100
    
    let containerView = UIView()
    let dateLabel = UILabel()
    let textLabel1 = UILabel()
    let textLabel2 = UILabel()
    let textLabel3 = UILabel()
    
    private var _date : NSDate?
    var date : NSDate? {
        get {
            return _date
        }
        set {
            _date = newValue
            
            if _date == nil {
                dateLabel.text = nil
                textLabel3.text = nil
                
            } else {
                let df = NSDateFormatter()
                let attributedString = NSMutableAttributedString()
                
                df.dateFormat = "dd\n"
                attributedString.appendAttributedString(NSAttributedString(string: df.stringFromDate(_date!), attributes: [
                        NSForegroundColorAttributeName: UIColor.blackColor(),
                        NSFontAttributeName: UIFont.systemFontOfSize(36, weight: UIFontWeightLight)
                    ]))
                
                df.dateFormat = "MMM"
                attributedString.appendAttributedString(NSAttributedString(string: df.stringFromDate(_date!).uppercaseString, attributes: [
                        NSForegroundColorAttributeName: UIColor(hexString: "D53D37"),
                        NSFontAttributeName: UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
                    ]))
                
                dateLabel.attributedText = attributedString
                
                df.dateFormat = "HH:mm"
                textLabel3.text = df.stringFromDate(_date!)
            }
        }
    }
    
    var title : String? {
        get {
            return textLabel1.text
        }
        set {
            textLabel1.text = newValue
        }
    }
    
    var address : String? {
        get {
            return textLabel2.text
        }
        set {
            textLabel2.text = newValue
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
        
        // configure views
        let views : [String:AnyObject] = [
            "containerView" : containerView,
            "dateLabel" : dateLabel,
            "textLabel1" : textLabel1,
            "textLabel2" : textLabel2,
            "textLabel3" : textLabel3,
        ]
        let metrics : [String:AnyObject] = [
            "containerMargin" : "5",
            "contentMarginH" : "10",
            "iconWidth" : "60",
            "iconHeight" : "60"
        ]
        
        // containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(hexString: "DFDEE1").CGColor
        self.contentView.addSubview(containerView)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-containerMargin-[containerView]-containerMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-containerMargin-[containerView]-containerMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // textIconView
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.numberOfLines = 0
        dateLabel.textAlignment = .Center
        containerView.addSubview(dateLabel)
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-contentMarginH-[dateLabel(iconWidth)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[dateLabel(iconHeight)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .CenterY, relatedBy: .Equal, toItem: dateLabel, attribute: .CenterY, multiplier: 1, constant: 0))
        
        // textLabel1
        textLabel1.translatesAutoresizingMaskIntoConstraints = false
        textLabel1.numberOfLines = 1
        textLabel1.font = UIFont.boldSystemFontOfSize(17)
        textLabel1.textColor = UIColor.blackColor()
        textLabel1.adjustsFontSizeToFitWidth = false
        textLabel1.lineBreakMode = .ByTruncatingTail
        containerView.addSubview(textLabel1)
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[dateLabel]-contentMarginH-[textLabel1]-contentMarginH-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[textLabel1(>=20)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraint(NSLayoutConstraint(item: textLabel1, attribute: .Top, relatedBy: .Equal, toItem: dateLabel, attribute: .Top, multiplier: 1, constant: 0))
        
        // textLabel2
        textLabel2.translatesAutoresizingMaskIntoConstraints = false
        textLabel2.numberOfLines = 1
        textLabel2.font = UIFont.systemFontOfSize(15)
        textLabel2.textColor = UIColor(hexString: "616161")
        textLabel2.adjustsFontSizeToFitWidth = false
        textLabel2.lineBreakMode = .ByTruncatingTail
        containerView.addSubview(textLabel2)
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[dateLabel]-contentMarginH-[textLabel2]-contentMarginH-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[textLabel1]-1-[textLabel2(>=20)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // textLabel3
        textLabel3.translatesAutoresizingMaskIntoConstraints = false
        textLabel3.numberOfLines = 1
        textLabel3.font = UIFont.systemFontOfSize(15)
        textLabel3.textColor = UIColor(hexString: "ADADAD")
        textLabel3.adjustsFontSizeToFitWidth = false
        textLabel3.lineBreakMode = .ByTruncatingTail
        containerView.addSubview(textLabel3)
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[dateLabel]-contentMarginH-[textLabel3]-contentMarginH-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[textLabel2]-1-[textLabel3(>=20)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
