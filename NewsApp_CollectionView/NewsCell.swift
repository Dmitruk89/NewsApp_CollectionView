//
//  NewsTableViewCell.swift
//  NewsAPI_TableView
//
//  Created by Mac on 08.12.2023.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let description: String
    let imageUrl: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        description: String,
        imageUrl: URL?
    ) {
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
    }
}

class NewsCollectionViewCell: UICollectionViewCell {
    
    var didSelectItem: (() -> Void)?

    static let identifier = "NewsCollectionViewCell"
    
    private let newsTitleLabel = UILabel()
    private let newsDescriptionLabel = UILabel()
    private let newsImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    func configureLabel() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
        
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.adjustsFontForContentSizeCategory = true
        newsTitleLabel.numberOfLines = 0
        
        newsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        newsDescriptionLabel.adjustsFontForContentSizeCategory = true
        newsDescriptionLabel.numberOfLines = 0
        
        newsImageView.layer.masksToBounds = true
        newsImageView.clipsToBounds = true
        newsImageView.backgroundColor = .secondarySystemBackground
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(newsDescriptionLabel)
        contentView.addSubview(newsImageView)
        
        newsTitleLabel.font = .monospacedDigitSystemFont(ofSize: 17, weight: .semibold)
        newsDescriptionLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        
        let inset = CGFloat(5)
        NSLayoutConstraint.activate([
            newsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            newsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -140),
            newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            newsTitleLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),

            newsDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            newsDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -150),
            newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: inset),
            newsDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            
            newsImageView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -140),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            newsImageView.widthAnchor.constraint(equalToConstant: 140),
            ])
        }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        newsDescriptionLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        newsDescriptionLabel.text = viewModel.description
        
        ImageLoader.shared.loadImage(from: viewModel.imageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.newsImageView.image = image
                }
        }
    }
    
    @objc func cellTapped() {
        didSelectItem?()
        }
    
}
