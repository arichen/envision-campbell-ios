//
//  DocumentListViewController.swift
//  EnvisionCampbell
//
//  Created by Ari Chen on 1/6/16.
//  Copyright © 2016 Ari Chen. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import ContentfulDeliveryAPI
import AirshipKit
import AVKit
import AVFoundation

class DocumentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let client : CDAClient! = AppDelegate.shared.client
    var playerVC : AVPlayerViewController?
    var isLoading : Bool = false
    var dataSource : [CDAEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(DocumentCell.classForCoder(), forCellReuseIdentifier: DocumentCell.identifier)
        tableView.rowHeight = DocumentCell.cellHeight
        tableView.backgroundColor = UIColor.clearColor()
        
        reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Data
    func reloadData() {
        isLoading = true
        self.client.fetchEntriesMatching(
            [
                "content_type" : "document",
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
        return (isLoading == true) ? NSAttributedString(string: "Loading...") : NSAttributedString(string: "No Documents")
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DocumentCell.identifier, forIndexPath: indexPath) as! DocumentCell
        
        let df = NSDateFormatter()
        df.dateStyle = .MediumStyle
        
        let item : CDAEntry = dataSource[indexPath.row]
        cell.titleLabel.text = item.fields["title"] as? String
        cell.dateLabel.text = df.stringFromDate(item.sys["updatedAt"] as! NSDate)
        
        if let file = item.fields["file"] as? CDAAsset {
            cell.MIMEType = file.MIMEType
        } else {
            cell.MIMEType = nil
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item : CDAEntry = dataSource[indexPath.row]
        let title : String = item.fields["title"] as? String ?? ""
        
        if let link = item.fields["link"] as? String {
            openWebViewer(NSURL(string: link)!, title: title)
        } else if let asset = item.fields["file"] as? CDAAsset {
            openWebViewer(asset.URL!, title: title)
        }
    }
    
    func openWebViewer(url: NSURL, title: String) {
        UAirship.shared().analytics.addEvent(UACustomEvent(name: "view_document"))
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("webview") as! WebViewController
        vc.URL = url
        vc.title = title
        vc.isDocumentView = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

