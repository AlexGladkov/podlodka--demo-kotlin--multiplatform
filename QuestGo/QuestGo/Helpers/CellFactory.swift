//
//  CellFactory.swift
//  ReviewController
//
//  Created by Алексей Гладков on 07.07.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
    associatedtype DataType
    func setup(data: DataType)
}

extension ConfigurableCell {
    func setup(data: Any) {
        // Protocol stub
    }
}

protocol CellConfigurator {
    static var cellReuseIdentifier: String { get }
    func setup(cell: UIView)
}

class TableCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {

    static var cellReuseIdentifier: String { return String(describing: CellType.self) }

    let item: DataType

    init(item: DataType) {
        self.item = item
    }

    func setup(cell: UIView) {
        guard let cellType = cell as? CellType else { return }

        cellType.setup(data: item)
    }
}
