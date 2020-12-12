//
//  HeaderCell.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell, ConfigurableCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var textTitleView: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(data: HeaderCellModel) {
        textTitleView.text = data.text
    }
}
