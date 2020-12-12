//
//  VideoCell.swift
//  QuestGo
//
//  Created by Алексей Гладков on 11.09.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoCell: UITableViewCell, ConfigurableCell {

    @IBOutlet private weak var videoView: YTPlayerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(data: VideoCellModel) {
        videoView.load(withVideoId: data.videoId)
    }
}
