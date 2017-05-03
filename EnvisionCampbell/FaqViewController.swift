//
//  FaqViewController.swift
//  EnvisionCampbell
//
//  Created by Ari Chen on 2/2/16.
//  Copyright © 2016 Ari Chen. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import ContentfulDeliveryAPI
import AirshipKit

class FaqViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    let photoView = UIImageView(image: UIImage(named: "citystaff"))
    
    let client : CDAClient! = AppDelegate.shared.client
    var isLoading : Bool = false
    var dataSource : [CDAEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(FaqCell.classForCoder(), forCellReuseIdentifier: FaqCell.identifier)
        tableView.rowHeight = FaqCell.cellHeight
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        initializeViews()
        reloadData()
    }
    
    func initializeViews() {
        self.view.backgroundColor = UIColor(hexString: "F7F3EF")
        
        // configure views
        let views : [String : AnyObject] = [
            "top" : self.topLayoutGuide,
            "tableView" : tableView,
            "photoView" : photoView,
        ]
        
        self.view.addSubview(tableView)
        self.view.addSubview(photoView)
        
        photoView.contentMode = .ScaleAspectFill
        photoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[photoView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[top][photoView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraint(NSLayoutConstraint(item: photoView, attribute: .Height, relatedBy: .Equal, toItem: photoView, attribute: .Width, multiplier: 0.33, constant: 0))
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[photoView]-[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    func reloadData() {
        isLoading = true
        self.client.fetchEntriesMatching(
            [
                "content_type" : "faq",
                "order" : "-sys.updatedAt"
            ],
            success: { (response : CDAResponse, array : CDAArray) -> Void in
                self.isLoading = false
                self.dataSource = array.items as! [CDAEntry]
                self.tableView.reloadData()
                
            }, failure: { (response : CDAResponse?, error : NSError) -> Void in
                self.isLoading = false
                self.tableView.reloadData()
                let alert : UIAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    // MARK: DZNEmptyDataSetSource
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return (isLoading == true) ? NSAttributedString(string: "Loading...") : NSAttributedString(string: "Oops...")
    }
    
    //UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FaqCell.identifier, forIndexPath: indexPath) as! FaqCell
        
        let item : CDAEntry = dataSource[indexPath.row]
        cell.titleLabel.text = item.fields["question"] as? String
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UAirship.shared().analytics.addEvent(UACustomEvent(name: "view_faq"))
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("faqDetail") as! FaqDetailViewController
        vc.data = dataSource[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
