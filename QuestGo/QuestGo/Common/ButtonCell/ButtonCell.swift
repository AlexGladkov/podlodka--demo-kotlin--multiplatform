//
//  ButtonCell.swift
//  QuestGo
//
//  Created by Алексей Гладков on 07.09.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate: class {
    func didButtonTap(model: ButtonCellModel)
}

class ButtonCell: UITableViewCell, ConfigurableCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var buttonActionView: UIButton!

    // MARK: - External vars
    weak var delegate: ButtonCellDelegate?

    // MARK: - Internal vars
    private var model: ButtonCellModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        buttonActionView.addTarget(self, action: #selector(didTouch), for: .touchUpInside)
        buttonActionView.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func didTouch() {
        guard let model = model else { return }
        
        delegate?.didButtonTap(model: model)
    }

    func setup(data: ButtonCellModel) {
        model = data
        buttonActionView.setTitle(data.buttonTitle, for: .normal)
    }
}
