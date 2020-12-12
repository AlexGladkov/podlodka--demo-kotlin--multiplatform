//
//  UIViewController+NavigationBar.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setMultilineNavigationBar(topText:  String, bottomText : String) {
        let topTxt = NSLocalizedString(topText, comment: "")
        let bottomTxt = NSLocalizedString(bottomText, comment: "")

        let titleParameters = [NSAttributedString.Key.foregroundColor : UIColor.black,
                               NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30, weight: .semibold)]
        let subtitleParameters = [NSAttributedString.Key.foregroundColor : UIColor.black,
                                  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .regular)]

        let title:NSMutableAttributedString = NSMutableAttributedString(string: topTxt, attributes: titleParameters)
        let subtitle:NSAttributedString = NSAttributedString(string: bottomTxt, attributes: subtitleParameters)

        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)

        let size = title.size()

        let width = size.width
        guard let height = navigationController?.navigationBar.frame.size.height else {return}

        let titleLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        self.navigationItem.titleView = titleLabel
    }
}
