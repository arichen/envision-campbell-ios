//
//  DocumentCell.swift
//  EnvisionCampbell
//
//  Created by Ari Chen on 1/20/16.
//  Copyright © 2016 Ari Chen. All rights reserved.
//

import UIKit

class DocumentCell: UITableViewCell {
    static let identifier : String = "documentCell"
    static let cellHeight : CGFloat = 100
    
    let containerView = UIView()
    let textIconView = TextIconView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    
    var MIMEType : String? {
        get {
            return textIconView.MIMEType
        }
        set {
            textIconView.MIMEType = newValue
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
            "textIconView" : textIconView,
            "titleLabel" : titleLabel,
            "dateLabel" : dateLabel,
        ]
        let metrics : [String:AnyObject] = [
            "containerMargin" : "5",
            "contentMarginH" : "10",
            "textIconWidth" : "60",
            "textIconHeight" : "60"
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
        textIconView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textIconView)
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-contentMarginH-[textIconView(textIconWidth)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[textIconView(textIconHeight)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .CenterY, relatedBy: .Equal, toItem: textIconView, attribute: .CenterY, multiplier: 1, constant: 0))
        
        // titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.boldSystemFontOfSize(17)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .ByTruncatingTail
        containerView.addSubview(titleLabel)
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[textIconView]-contentMarginH-[titleLabel]-contentMarginH-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleLabel(>=20)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: textIconView, attribute: .Top, multiplier: 1, constant: 0))
        
        // dateLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont.systemFontOfSize(14)
        dateLabel.textColor = UIColor(hexString: "ADADAD")
        containerView.addSubview(dateLabel)
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[textIconView]-contentMarginH-[dateLabel]-contentMarginH-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleLabel]-1-[dateLabel(>=21)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TextIconView : UIView {
    let MIME_TO_EXTENSION = [
        "application/msword" : "doc",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" : "docx",
        "application/vnd.ms-excel" : "xls",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" : "xlsx",
        "application/vnd.ms-powerpoint" : "ppt",
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" : "pptx",
        "application/pdf" : "pdf",
        "video/mp4" : "mp4"
    ]
    
    let COLOR_BY_FILE_TYPE = [
        "pdf"   : UIColor(hexString: "D53D37"),
        "doc"   : UIColor(hexString: "5491F2"),
        "docx"  : UIColor(hexString: "5491F2"),
        "xls"   : UIColor(hexString: "26A162"),
        "xlsx"  : UIColor(hexString: "26A162"),
        "ppt"   : UIColor(hexString: "F2B737"),
        "pptx"  : UIColor(hexString: "F2B737"),
        "mp4"   : UIColor(hexString: "145252"),
        "file"  : UIColor(hexString: "673AB7")
    ]
    
    private var _MIMEType : String?
    var MIMEType : String? {
        get {
            return _MIMEType
        }
        set {
            _MIMEType = newValue
            
            var fileExt = (newValue != nil) ? MIME_TO_EXTENSION[newValue!] : nil
            fileExt = fileExt != nil ? fileExt : "file"
            let color = COLOR_BY_FILE_TYPE[fileExt!]
            
            titleLabel.text = fileExt?.uppercaseString
            titleLabel.textColor = color!
            titleLabel.layer.borderColor = color!.CGColor
        }
    }
    
    private var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // default settings
        self.backgroundColor = UIColor.whiteColor()
        
        self.titleLabel.layer.cornerRadius = 8
        self.titleLabel.layer.borderWidth = 1
        
        self.titleLabel.textAlignment = NSTextAlignment.Center
        self.titleLabel.font = UIFont.systemFontOfSize(20, weight: UIFontWeightLight)
        
        MIMEType = nil
        
        // configure views
        let views : [String:AnyObject] = [
            "titleLabel" : titleLabel
        ]
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-1-[titleLabel]-1-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[titleLabel]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}