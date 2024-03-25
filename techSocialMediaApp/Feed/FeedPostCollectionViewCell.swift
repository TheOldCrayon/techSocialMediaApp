import UIKit

class FeedPostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postUsernameLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    
    @IBOutlet weak var postLikesLabel: UILabel!
    @IBOutlet weak var postCommentLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
}
