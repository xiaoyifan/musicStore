//
//  ViewController.swift
//  musicStore
//
//  Created by Yifan Xiao on 4/20/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

import UIKit
import musicStoreKit
import CoreData
import Parse

class ViewController: UIViewController {
    
    var objects:NSArray!
    var count:Int = 0
    
    @IBOutlet weak var iconCountLabel: UILabel!
    
    @IBOutlet weak var downloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        DataManager.sharedInstance.clearData("App", context: context)
    }
    

    @IBAction func startDownloadButton(sender: AnyObject) {
        
        self.downloadButton.enabled = false;
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        DataManager.sharedInstance.clearData("App", context: context)
        
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://itunes.apple.com/search?term=music&country=us&entity=software&limit=200")!)
        
        //for the block, block parameters will be called
        Networking.sharedInstance.get(request){
            (data, error) -> Void in
            if error != nil {
                println(error)
            } else {
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                    self.objects = dataParsing.sharedInstance.parse(data)
                    
                    self.downloadIcons(self.objects)
                    
                    var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    var context:NSManagedObjectContext = appDel.managedObjectContext!
                    
                    DataManager.sharedInstance.saveDataToCloud(self.objects, context: context)
                })
                
                
            }
        }
        
    }
    
    func downloadIcons(objects:NSArray!)
    {
        for item in objects as! [appItem]
        {
            var urlString:NSString = item.artworkUrl60
            var request = NSMutableURLRequest(URL: NSURL(string: urlString as String)!)
            
            Networking.sharedInstance.get(request){
                (dataDownloaded, error) -> Void in
                if error != nil {
                    println(error)
                } else {
                    
                    
                        let dataPic = (dataDownloaded as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                        item.appIcon = dataPic
                        
                        self.count++;
                    
                    dispatch_async(dispatch_get_main_queue(), {

                        
                        println("\(self.count) icons downloaded")
                        
                        if self.objects.count == 200 && self.count == 200 {
                            self.iconCountLabel.text = "downloaded completed"
                            self.downloadButton.enabled = true;
                        }
                        
                    })
                    
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

