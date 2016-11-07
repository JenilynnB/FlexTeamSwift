//
//  ChatViewController.swift
//  SwiftExample
//
//  Created by Dan Leonard on 5/11/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit

import PubNub
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController, PNObjectEventListener {
    
    var client = PubNub.client(with: PNConfiguration(publishKey: "pub-c-04f04d57-09d0-428a-9ca9-c750a0811e17", subscribeKey: "sub-c-e6204314-8430-11e6-a68c-0619f8945a4f"))
    var channel = "chat-swift"

    var incomingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero).incomingMessagesBubbleImage(with: UIColor(red: 241/255, green: 240/255, blue: 240/255, alpha: 1.0))
    var outgoingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleRegularTailless(), capInsets: UIEdgeInsets.zero).outgoingMessagesBubbleImage(with: UIColor(red: 102/255, green: 161/255, blue: 230/255, alpha: 1.0))
    

    var messages = [JSQMessage]()
    
    var currentUser: User?
    var dateFormatter = DateFormatter()
    
    
    func setup(){
        
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .none
        self.dateFormatter.locale = Locale(identifier: "en_US")
        self.dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        let defaults = UserDefaults.standard
        let firstName = defaults.string(forKey: "firstName")
        let lastName = defaults.string(forKey: "lastName")
        let userID = defaults.string(forKey: "userID")
        let authToken = defaults.string(forKey: "authToken")
        
        currentUser = User(firstName: firstName!, lastName: lastName!, userID: userID!, authToken: authToken!)
        
        self.senderId = currentUser?.userID
        self.senderDisplayName = (currentUser?.firstName)! + " " + (currentUser?.lastName)!
        
        client.subscribe(toChannels: [channel], withPresence: false)
        
        client.add(self)
        
    }
   
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        let data = message.data
        print(data)
        var m = data.message as! Dictionary<String, Any>
        print(m)

        guard
            let senderId = m["senderId"] as? String,
            let senderDisplayName = m["senderDisplayName"] as? String,
            let date = m["date"] as? String,
            let text = m["text"] as? String
        else {
                return;
        }
 
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: dateFormatter.date(from: date), text: text)
        self.messages.append(message!)
        self.reloadMessagesView()
    }

    
    //fileprivate var displayName: String!
    
    override func viewDidLoad() {
        setup()
        
        super.viewDidLoad()
        
        // This is a beta feature that mostly works but to make things more stable it is diabled.
        collectionView?.collectionViewLayout.springinessEnabled = false
        
        automaticallyScrollsToMostRecentMessage = true
        
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
    }
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        //let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        let newDate = dateFormatter.string(from: date)
        let message = ["senderId": senderId, "senderDisplayName": senderDisplayName, "date": newDate, "text": text] as [String : Any]
        
        client.publish(message, toChannel: channel, compressed: false, withCompletion: nil)
        
        self.finishSendingMessage()
    }


    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
 
    /*
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: outgoingCellIdentifier, for: indexPath) as! JSQMessagesCollectionViewCell
        
    
        return cell
    }
 */
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let data = messages[indexPath.row]
        
        let displayName = data.senderDisplayName
        
        var spaceIndex = displayName?.characters.index(of: " ")
        var firstName, lastName, firstInitial, lastInitial: String?
        
        var initialIndex: String.Index
        if(spaceIndex != nil){
            
            spaceIndex = displayName?.index(spaceIndex!, offsetBy: 1)
            
            firstName = displayName?.substring(to: spaceIndex!)
            lastName = displayName?.substring(from: spaceIndex!)
            initialIndex = (lastName?.index((lastName?.startIndex)!, offsetBy: 1))!
            lastInitial = lastName?.substring(to: initialIndex)
        }else{
            firstName = displayName
            lastName = ""
            lastInitial = ""
        }
        
        initialIndex = (firstName?.index((firstName?.startIndex)!, offsetBy: 1))!
        firstInitial = firstName?.substring(to: initialIndex)
        
        return JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: firstInitial! + lastInitial!, backgroundColor: UIColor(red: 53/255, green: 83/255, blue: 118/255, alpha: 1.0), textColor: UIColor.white, font: UIFont(name: "Arial", size: 30), diameter: 60)
        
    }

}




