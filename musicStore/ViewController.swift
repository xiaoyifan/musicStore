//
//  ViewController.swift
//  musicStore
//
//  Created by Yifan Xiao on 4/20/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

import UIKit
import musicStoreKit

class ViewController: UIViewController {
    
    var objects:NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://itunes.apple.com/search?term=music&country=us&entity=software")!)
        Networking.sharedInstance.get(request){
            (data, error) -> Void in
            if error != nil {
                println(error)
            } else {
                //println(data)
                self.objects = dataParsing.sharedInstance.parse(data)
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

