//
//  ProfileTableViewController.swift
//  techSocialMediaApp
//
//  Created by Marek Neumarker on 2/22/24.
//

import UIKit



class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var profileRealnameLabel: UILabel!
    @IBOutlet weak var profileBioLabel: UILabel!
    @IBOutlet weak var profileTechLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchProfile()
        
        tableView.reloadData()
    }
    func fetchProfile() {
        guard let userSecret = User.current?.secret else {
            print("User secret is nil")
            return
        }
        
        guard let userID = User.current?.userUUID else {
            print("User ID is nil")
            return
        }
        
        let queryParams = [
            "userUUID": "\(userID)",
            "userSecret": "\(userSecret)"
        ]
        
        guard let profileURL = API.profileURL else {
            print("Profile URL is nil")
            return
        }
        
        URLSession.shared.request(url: profileURL, method: .get, body: nil, queryParams: queryParams) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let profile = try JSONDecoder().decode(Profile.self, from: data)
                    DispatchQueue.main.async {
                        self?.profileUsernameLabel.text = profile.userName
                        self?.profileRealnameLabel.text = "\(profile.firstName) \(profile.lastName)"
                        self?.profileBioLabel.text = profile.bio
                        self?.profileTechLabel.text = profile.techInterests
                    }
                } catch {
                    print("Error decoding profile: \(error)")
                }
            case .failure(let error):
                print("Error fetching profile: \(error)")
            }
        }
    }
    @IBAction func unwindFromEditProfile(segue: UIStoryboardSegue) {
        
    }
}
