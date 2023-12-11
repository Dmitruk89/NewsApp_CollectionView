//
//  NewsDetailViewController.swift
//  NewsApp_CollectionView
//
//  Created by Mac on 10.12.2023.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    var article: Article
    private let newsTitleLabel = UILabel()
    private let newsDescriptionLabel = UILabel()
    private let newsImageView = UIImageView()
    
    init(article: Article) {
            self.article = article
            super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("no init coder")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailView()
    }
    
    private func configureDetailView() {
        view.backgroundColor = .systemBackground
            
        newsTitleLabel.text = article.title
        newsTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        newsTitleLabel.numberOfLines = 0
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        newsDescriptionLabel.text = article.description
        newsDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        newsDescriptionLabel.numberOfLines = 0
        newsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        ImageLoader.shared.loadImage(from: URL(string: article.urlToImage ?? "")) { [weak self] image in
                DispatchQueue.main.async {
                    print("image is here!!")
                    self?.newsImageView.image = image
                }
        }
        newsImageView.layer.masksToBounds = true
        newsImageView.clipsToBounds = true
        newsImageView.backgroundColor = .secondarySystemBackground
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.translatesAutoresizingMaskIntoConstraints = false

        let scrollView = UIScrollView()
           scrollView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(scrollView)

           scrollView.addSubview(newsImageView)
           scrollView.addSubview(newsTitleLabel)
           scrollView.addSubview(newsDescriptionLabel)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 600)

            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                newsImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                newsImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                newsImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                newsImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                newsImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
                
                
                newsTitleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 16),
                newsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                newsTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

                newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 8),
                newsDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                newsDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                newsDescriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            ])
    }
}
