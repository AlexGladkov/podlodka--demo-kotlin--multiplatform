//
//  TextButtonCell.swift
//  QuestGo
//
//  Created by Алексей Гладков on 08.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol TextButtonCellDelegate: class {
    func buttonTapped(model: TextButtonCellModel)
}

class TextButtonCell: UITableViewCell, ConfigurableCell {

    @IBOutlet weak var textButtonView: UIButton!
    private var model: TextButtonCellModel?

    weak var delegate: TextButtonCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let model = model else { return }
        
        delegate?.buttonTapped(model: model)
    }

    func setup(data: TextButtonCellModel) {
        self.model = data

        textButtonView.setTitle(data.title, for: .normal)
    }
}
