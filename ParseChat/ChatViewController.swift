//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Pavani Malli on 6/26/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    
    var chatMessages: [PFObject] = []
    
    @IBAction func sendMessage(_ sender: UIButton) {
        let chatMessage = PFObject(className: "Message_fbuJuly2017")
        chatMessage["text"] = messageText.text ?? ""
        print("here:\(PFUser.getCurrentUserInBackground())")
        chatMessage["user"] = PFUser.current()
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    func queryParse() {
        let query = PFQuery(className: "Message_fbuJuly2017")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        
        query.findObjectsInBackground() { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.chatMessages = posts
                self.chatTableView.reloadData()
            
            }
            else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as!ChatTableViewCell
        
        let message = (chatMessages[indexPath.row]["text"] ?? "") as! String
        
        if chatMessages[indexPath.row]["user"] != nil {
            let user = chatMessages[indexPath.row]["user"] as! PFUser
            cell.userLabel.text = user.username as! String
        }
        
        cell.messageLabel.text = message
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegate to table view
        chatTableView.dataSource = self
        chatTableView.delegate = self
        
        // Fetch messages every second
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryParse), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
