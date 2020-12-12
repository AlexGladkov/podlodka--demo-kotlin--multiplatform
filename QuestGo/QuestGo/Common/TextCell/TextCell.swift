//
//  TextCell.swift
//  QuestGo
//
//  Created by Алексей Гладков on 16.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell, ConfigurableCell {

    @IBOutlet private weak var contentTextView: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(data: TextCellModel) {
        contentTextView.text = data.text
    }
}
