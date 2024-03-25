//
//  CreateCommentTableViewController.swift
//  techSocialMediaApp
//
//  Created by Marek Neumarker on 2/22/24.
//

import UIKit

class CreateCommentTableViewController: UITableViewController {

    var postid: Int?
    
    var comment: Comment?
    
    @IBOutlet weak var comentTextField: UITextField!
    @IBOutlet weak var commentSaveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        updateSaveButton()
        super.viewDidLoad()
    }
    func updateSaveButton() {
        let text = comentTextField.text ?? ""
        commentSaveButton.isEnabled = !text.isEmpty
    }
    @IBAction func editingChanged(_ sender: Any) {
        updateSaveButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "commentUnwind" else { return }
        
        let bodyText = comentTextField.text ?? ""
        
        createCommentRequest(textBody: bodyText)
    }
    func createCommentRequest(textBody: String) {
        guard let url = API.createCommentURL else { return }
        
        if let userSecret = User.current?.secret {
            if let postid = postid {
                let queryParams: [String: Any] = [
                    "userSecret": "\(userSecret)",
                    "commentBody": "\(textBody)",
                    "postid": "\(postid)"
                ]
                
                URLSession.shared.request(url: url, method: .post, body: nil, queryParams: queryParams) { result in
                    switch result {
                    case .success(let data):
                        
                        print("Success: \(data)")
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            } else {
                print("postid don't wurk")
            }
        } else {
            print("secret don't wurk")
        }
    }
    
}
