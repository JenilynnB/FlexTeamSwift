//
//  LoginVC.swift
//  FlexTeam
//
//  Created by Jennifer Brandes on 11/4/16.
//  Copyright © 2016 Jennifer Brandes. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 4
        
        footerView.layer.borderWidth = 1
        footerView.layer.borderColor = UIColor.white.cgColor
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonClick(_ sender: Any) {
        let headers = ["Accept": "application/json", "Content-Type": "application/json"];
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let body = ["username": email, "password": password]
        //let body = "username="+email+"&password="+password
        let remote = Remote()
        
        /*
        remote.getRemote("/api/auth/login", method: .post, headers: headers, body: body, completion: {jsonString in
            print(jsonString)
        })
        */
        
        remote.getRemote(url: "/auth/login", method: .post, headers: headers, body: body, completion: {responseDict in
            guard let authToken = responseDict["accessToken"] as! String? else { return }
            guard let profile = responseDict["profile"] as! NSDictionary? else {return}
            guard let userID = profile["id"] as! String? else {return}
            
            let firstName = profile["firstName"] as! String?
            let lastName = profile["lastName"] as! String?
            
            let defaults = UserDefaults.standard
            defaults.set(firstName, forKey: "firstName")
            defaults.set(lastName, forKey: "lastName")
            defaults.set(userID, forKey: "userID")
            
            /*TODO: USE KEYCHAIN TO STORE, DO NOT USE USER DEFAULTS*/
            defaults.set(authToken, forKey: "authToken")
            
            DispatchQueue.main.async(execute:
                {
                self.performSegue(withIdentifier: "login", sender: self)
                })
            //self.performSegue(withIdentifier: "login", sender: sender)
        })
        
        
        
    }
    /*
    func saveUser(user: User){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(user, toFile: User.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            print("Failed to save user...")
        }
    }
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
