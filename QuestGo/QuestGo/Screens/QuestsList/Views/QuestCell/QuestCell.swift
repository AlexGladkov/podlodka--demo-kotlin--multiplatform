//
//  QuestCell.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit
import AlamofireImage

class QuestCell: UITableViewCell, ConfigurableCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var titleView: UILabel!
    @IBOutlet private weak var subtitleView: UILabel!
    @IBOutlet private weak var previewView: UIImageView!
    @IBOutlet private weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        containerView.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(data: QuestCellModel) {
        titleView.text = data.title
        subtitleView.text = data.subtitle

        guard let imageUrl = data.image else { return }
        previewView.af.setImage(withURL: imageUrl, filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: previewView.frame.size, radius: 6), imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true)
    }
}
