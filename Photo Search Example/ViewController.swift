//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Andrew Udell on 9/23/14.
//  Copyright (c) 2014 Andrew Udell. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UIScrollView!
    
    let instagramClientID = "031cb114e2bb4e0d8aeb55075a053089"
    
    func searchInstagramByHashtag(searchString: String) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        let instagramURLString = "https://api.instagram.com/v1/tags/" + searchString + "/media/recent?client_id=" + instagramClientID
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET( instagramURLString,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println("JSON: " + responseObject.description)
                
                if let dataArray = responseObject.valueForKey("data") as? [AnyObject] {
                    self.scrollView.contentSize = CGSizeMake(320, CGFloat(320*dataArray.count))
                    for var i = 0; i < dataArray.count; i++ {
                        let dataObject: AnyObject = dataArray[i]
                        if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                            println("image " + String(i) + " URL is " + imageURLString)
                            
                            let imageView = UIImageView(frame: CGRectMake(0, CGFloat(320*i), 320, 320))
                            self.scrollView.addSubview(imageView)
                            imageView.setImageWithURL( NSURL(string: imageURLString))
                        }
                    }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        
        searchBar.resignFirstResponder()
        searchInstagramByHashtag(searchBar.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInstagramByHashtag("clararockmore")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

