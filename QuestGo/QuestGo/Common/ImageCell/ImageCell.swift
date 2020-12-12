//
//  ImageCell.swift
//  QuestGo
//
//  Created by Алексей Гладков on 16.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit
import AlamofireImage

protocol ImageCellDelegate: class {
    func didImageTap(url: URL?)
}

class ImageCell: UITableViewCell, ConfigurableCell {

    @IBOutlet private weak var contentImageView: UIImageView!
    @IBOutlet private weak var loaderView: UIActivityIndicatorView!

    weak var delegate: ImageCellDelegate?

    private var url: URL?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        contentImageView.isUserInteractionEnabled = true
        contentImageView.addGestureRecognizer(singleTap)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        contentImageView.image = nil
    }

    func setup(data: ImageCellModel) {
        self.url = data.imageUrl

        guard let url = data.imageUrl else { return }

        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: contentImageView.frame.size, radius: 8)
        contentImageView.af.setImage(withURL: url, filter: filter)

        loaderView.startAnimating()
        contentImageView.af.setImage(withURL: url, filter: filter, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true) { [weak self] _ in
            self?.loaderView.stopAnimating()
        }
    }

    @objc private func imageTap() {
        delegate?.didImageTap(url: url)
    }
}
