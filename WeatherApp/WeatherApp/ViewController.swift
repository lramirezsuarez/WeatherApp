//
//  ViewController.swift
//  WeatherApp
//
//  Created by Luis Ramirez on 6/15/17.
//  Copyright © 2017 Lucho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    
    var message = ""
    let baseURL = "http://www.weather-forecast.com/locations/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }


    @IBAction func didSearchCity(_ sender: Any) {
        if(cityTextField.text != "") {
            let urlString = baseURL + "\(cityTextField.text!.replacingOccurrences(of: " ", with: "-"))/forecasts/latest"
            let urlRequest = URLRequest(url: URL(string: urlString)!)
            
            let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
                data, response, error in
                
                if(error != nil) {
                    print("There was an error.")
                } else {
                    if let recievedData = data {
                        let dataString = NSString(data: recievedData, encoding: String.Encoding.utf8.rawValue)
                        
                        var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            
                            if contentArray.count > 1 {
                                
                                stringSeparator = "</span>"
                                
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                
                                if newContentArray.count > 1 {
                                    self.message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "º")
                                }
                            }
                        }
                    }
                }
                
                if self.message == "" {
                    self.message = "The Weather in \(self.cityTextField.text!) has not been found. Please try again."
                }
                
                DispatchQueue.main.sync(execute: {
                    self.weatherLabel.text = self.message
                })
            }
            

            
            task.resume()
            
            
        } else {
            let alert = UIAlertController(title: "Text Field Alert!", message: "The text field is empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    

}

