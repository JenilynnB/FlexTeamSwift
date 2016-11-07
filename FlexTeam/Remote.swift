//
//  Remote.swift
//  FlexTeam
//
//  Created by Jennifer Brandes on 11/4/16.
//  Copyright © 2016 Jennifer Brandes. All rights reserved.
//

import Foundation


class Remote {

    let endpoint = "http://flexteam-dev.herokuapp.com/api"
    let config = URLSessionConfiguration.default // Session Configuration
    //  let url = URL(string: "https://flexteam-app.heroku.com/api/list/myList")!

    
    enum method: String{
        case post = "POST"
        case get = "GET"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    init(){
        
        
    }
    
    func getRemote(url: String, method: method, headers: [String: String], body: [String:String], completion: @escaping (Dictionary<String, Any>)->()){
        
        guard let url = URL(string: endpoint + url) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        do{
            let jsonBody = try JSONSerialization.data(withJSONObject: body, options: [])
            //let dataBody = body.data(using: .utf8)
            
            urlRequest.httpBody = jsonBody
            urlRequest.allHTTPHeaderFields = headers
            
            print(urlRequest.url)
            print(NSString(data: urlRequest.httpBody!, encoding: String.Encoding.utf8.rawValue)!)
            print(urlRequest.httpMethod)
            print(urlRequest.allHTTPHeaderFields)
            
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {data, response, error -> Void in
                if(error == nil){
                    if let data = data {
                        let jsonString = String(data: data, encoding: String.Encoding.utf8)
                        let result = self.convertStringToDictionary(text: jsonString!)
                        completion(result!)
                        
                    } else {
                    print("error=\(error!.localizedDescription)")
                }
                    
                }
            })
            task.resume()
        }catch{
           
        }
        
        

    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

}
