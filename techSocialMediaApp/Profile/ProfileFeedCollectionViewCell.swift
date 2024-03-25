//
//  ProfileFeedCollectionViewCell.swift
//  techSocialMediaApp
//
//  Created by Marek Neumarker on 2/22/24.
//

import UIKit

class ProfileFeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileTitleLabel: UILabel!
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var profileBodyLabel: UILabel!
    
    @IBOutlet weak var profileLikes: UILabel!
    @IBOutlet weak var profileComments: UILabel!
    @IBOutlet weak var profileDate: UILabel!
}
