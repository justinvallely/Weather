//
//  ViewController.swift
//  Weather
//
//  Created by Justin Vallely on 5/19/15.
//  Copyright (c) 2015 JMVapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var userCity: UITextField!

    @IBOutlet var resultLabel: UILabel!
    @IBAction func findWeather(sender: AnyObject) {
        
        // URL specific for weather-forcast.com. Multi-word city names are hyphenated in the URL
        var url = NSURL(string: "http://www.weather-forecast.com/locations/" + userCity.text.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        // If the URL is valid
        if url != nil {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                
                var urlError = false
                
                var weather = ""
                
                // If no errors loading the page
                if error == nil {
                    
                    // Convert the content to readable html data
                    var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding) as NSString!
                    
                    // Parse the html for a specific location
                    var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                    
                    // If the page loaded correctly the array will contain more than one String location
                    if urlContentArray.count > 1 {
                        
                        // The second item in the array will contain the the data. Parse it for an ending String location
                        var weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                        
                        // Create a new variable with the weather data full parsed
                        weather = weatherArray[0] as! String
                        
                        // Convert any odd html coding to readable characters
                        weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        
                    } else {
                        urlError = true
                    }
                    
                } else {
                    urlError = true
                }
                
                // Used to show the error or the weather right away instead of waiting until the end of the queue
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if urlError == true {
                        
                        self.showError()
                        
                    } else {
                        
                        // If no errors, set the label equal to the fully parsed data
                        self.resultLabel.text = weather
                    }
                }
            })
            
            task.resume()
            
        } else {
            showError()
        }
    }
    
    func showError() {
        
        // Function created so that only one error String is needed
        resultLabel.text = "Was not able to find weather for \(userCity.text). Please try again."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

