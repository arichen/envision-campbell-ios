//
//  FaqDetailViewController.swift
//  EnvisionCampbell
//
//  Created by Ari Chen on 2/2/16.
//  Copyright © 2016 Ari Chen. All rights reserved.
//

import UIKit
import ContentfulDeliveryAPI
import AFNetworking

class FaqDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView : UIScrollView!
    
    var data : CDAEntry?
    
    let containerView = UIView()
    let questionLabel = UILabel()
    let answerLabel = UILabel()
    let dateLabel = UILabel()
    let separatorView = UIView()
    
    var imageView : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Q&A"
        
        initializeViews()
        initializeData()
    }
    
    func initializeViews() {
        self.view.backgroundColor = UIColor(hexString: "F7F3EF")
        
        // configure views
        var views : [String : AnyObject] = [
            "containerView" : containerView,
            "questionLabel" : questionLabel,
            "answerLabel" : answerLabel,
            "dateLabel" : dateLabel,
            "separator" : separatorView,
        ]
        var metrics : [String : CGFloat] = [
            "containerMargin" : 5,
            "contentMargin" : 13,
        ]
        
        // containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(hexString: "DFDEE1").CGColor
        scrollView.addSubview(containerView)
        
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-containerMargin-[containerView]-containerMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-containerMargin-[containerView(>=1)]-(>=containerMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        scrollView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1, constant: -2 * metrics["containerMargin"]!))
        
        // questionLabel
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.systemFontOfSize(20, weight: UIFontWeightMedium)
        containerView.addSubview(questionLabel)
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-contentMargin-[questionLabel]-contentMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // separator
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor(hexString: "DFDEE1")
        containerView.addSubview(separatorView)
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[separator]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // answerLabel
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.numberOfLines = 0
        answerLabel.font = UIFont.systemFontOfSize(17, weight: UIFontWeightThin)
        containerView.addSubview(answerLabel)
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-contentMargin-[answerLabel]-contentMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // dateLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.numberOfLines = 0
        dateLabel.font = UIFont.systemFontOfSize(13, weight: UIFontWeightUltraLight)
        dateLabel.textColor = UIColor.lightGrayColor()
        containerView.addSubview(dateLabel)
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-contentMargin-[dateLabel]-contentMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        
        // imageView
        
        if (data != nil) && (data!.fields["image"] as AnyObject? != nil) {
            imageView = UIImageView()
            imageView!.translatesAutoresizingMaskIntoConstraints = false
            imageView!.contentMode = .ScaleAspectFit
            imageView!.backgroundColor = UIColor.clearColor()
            containerView.addSubview(imageView!)
            
            views["imageView"] = imageView
            
            containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-contentMargin-[imageView]-contentMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
            scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-contentMargin-[questionLabel]-contentMargin-[separator(1)]-contentMargin-[imageView]-[answerLabel]-(>=contentMargin)-[dateLabel]-contentMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
            containerView.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .Height, relatedBy: .Equal, toItem: imageView!, attribute: .Width, multiplier: 1, constant: 0))
            
        } else {
            scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-contentMargin-[questionLabel]-contentMargin-[separator(1)]-contentMargin-[answerLabel]-(>=contentMargin)-[dateLabel]-contentMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        }
        
    }
    
    func initializeData() {
        if data != nil {
            questionLabel.text = data!.fields["question"] as? String
            answerLabel.text = data!.fields["answer"] as? String
            
            let df = NSDateFormatter()
            df.dateStyle = .MediumStyle
            dateLabel.text = df.stringFromDate(data!.sys["updatedAt"] as! NSDate)
            
            if let imageFile = data!.fields["image"] as? CDAAsset {
                print(imageFile.URL)
                imageView?.setImageWithURL(imageFile.URL)
            }
        }
    }
}
