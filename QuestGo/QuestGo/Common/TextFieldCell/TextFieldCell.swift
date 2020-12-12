//
//  TextFieldCell.swift
//  QuestGo
//
//  Created by Алексей Гладков on 08.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol TextFieldDelegate: class {
    func textDidChanged(identifier: Int, newValue: String)
}

class TextFieldCell: UITableViewCell, ConfigurableCell {

    @IBOutlet weak var textFieldView: UITextField!
    private var identifier: Int = -1

    weak var delegate: TextFieldDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        textFieldView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(data: TextFieldCellModel) {
        textFieldView.placeholder = data.hint
        identifier = data.identifier
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.textDidChanged(identifier: identifier, newValue: textField.text ?? "")
    }
}
