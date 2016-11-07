//
//  User.swift
//  
//
//  Created by Jennifer Brandes on 11/4/16.
//
//

import Foundation

class User: NSObject{

    let firstName: String?
    let lastName: String?
    let userID: String?
    let authToken: String?
    
    /* Archiving paths */
    
    //static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask)
    //static let ArchiveURL = DocumentsDirectory.a

    
    struct PropertyKey{
        static let firstNameKey = "firstName"
        static let lastNameKey = "lastName"
        static let userIDKey = "userID"
        static let authTokenKey = "authToken"
    }
    
    
    init(firstName: String, lastName: String, userID: String, authToken: String){
        self.firstName = firstName
        self.lastName = lastName
        self.userID = userID
        self.authToken = authToken
    }
    /*
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: PropertyKey.firstNameKey)
        aCoder.encode(lastName, forKey: PropertyKey.lastNameKey)
        aCoder.encode(userID, forKey: PropertyKey.userIDKey)
        aCoder.encode(authToken, forKey: PropertyKey.authTokenKey)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let firstName = aDecoder.decodeObject(forKey: PropertyKey.firstNameKey) as! String
        let lastName = aDecoder.decodeObject(forKey: PropertyKey.lastNameKey) as! String
        let userID = aDecoder.decodeObject(forKey: PropertyKey.userIDKey) as! String
        let authToken = aDecoder.decodeObject(forKey: PropertyKey.authTokenKey) as! String
        
        self.init(firstName: firstName, lastName: lastName, userID: userID, authToken: authToken)
    }
    */

}
