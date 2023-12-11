//
//  ViewController.swift
//  NewsApp_CollectionView
//
//  Created by Mac on 10.12.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    let newsService = NewsService()
    private var viewModels = [NewsTableViewCellViewModel]()
    var articles: [Article] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        
        fetchNews()
        setupColectionView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupColectionView(){
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func fetchNews(){
        newsService.fetchNews { [weak self] newsResponse in
            DispatchQueue.main.async {
                if let newsResponse = newsResponse {
                    self?.articles = newsResponse.articles
                    self?.viewModels = newsResponse.articles.compactMap({
                        NewsTableViewCellViewModel(
                            title: $0.title ?? "no title",
                            description: $0.description ?? "no description",
                            imageUrl: URL(string: $0.urlToImage ?? "")
                        )
                    })
                } else {
                    print("something went wrong")
                }
            }
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as? NewsCollectionViewCell else {
                return UICollectionViewCell()
        }
      
        cell.configure(with: viewModels[indexPath.row])
        
        cell.didSelectItem = { [weak self] in
                guard let selectedArticle = self?.articles[indexPath.row] else {
                    return
                }
                let detailViewController = NewsDetailViewController(article: selectedArticle)
                self?.navigationController?.pushViewController(detailViewController, animated: true)
            }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
}
