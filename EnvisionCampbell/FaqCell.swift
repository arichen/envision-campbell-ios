//
//  DocumentCell.swift
//  EnvisionCampbell
//
//  Created by Ari Chen on 1/20/16.
//  Copyright © 2016 Ari Chen. All rights reserved.
//

import UIKit

class FaqCell: UITableViewCell {
    static let identifier : String = "faqCell"
    static let cellHeight : CGFloat = 60
    
    let containerView = UIView()
    let titleLabel = UILabel()
    let iconView = UIImageView(image: UIImage(named: "ic_help"))
    private let separatorView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
        
        // configure views
        let views : [String:AnyObject] = [
            "containerView" : containerView,
            "titleLabel" : titleLabel,
            "iconView" : iconView,
            "separatorView" : separatorView,
        ]
        let metrics : [String:AnyObject] = [
            "containerMargin" : "0",
            "contentMarginH" : "20",
            "contentMarginV" : "8",
        ]
        
        // containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.whiteColor()
//        containerView.layer.borderWidth = 1
//        containerView.layer.borderColor = UIColor(hexString: "DFDEE1").CGColor
        self.contentView.addSubview(containerView)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-containerMargin-[containerView]-containerMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-containerMargin-[containerView]-containerMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        
        // iconView
        iconView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconView)
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-contentMarginH-[iconView(24)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[iconView(24)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraint(NSLayoutConstraint(item: iconView, attribute: .CenterY, relatedBy: .Equal, toItem: containerView, attribute: .CenterY, multiplier: 1, constant: 0))
        
        
        // titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.boldSystemFontOfSize(16)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .ByTruncatingTail
        containerView.addSubview(titleLabel)
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[iconView]-[titleLabel]-contentMarginH-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-contentMarginV-[titleLabel]-contentMarginV-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // separator
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor(hexString: "DFDEE1")
        containerView.addSubview(separatorView)
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[separatorView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[separatorView(1)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
