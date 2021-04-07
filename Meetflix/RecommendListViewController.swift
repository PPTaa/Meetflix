//
//  RecommendListViewController.swift
//  Meetflix
//
//  Created by leejungchul on 2021/04/04.
//


import UIKit

class RecommendListViewController: UIViewController {
    
    @IBOutlet weak var sectionTitle: UILabel!
    let viewModel = RecommendListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        sectionTitle.text = viewModel.type.title
        
    }
}

extension RecommendListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell else { return UICollectionViewCell() }
        let movie = viewModel.item(at: indexPath.item)
        cell.updateUI(movie: movie)
        return cell
    }
}

extension RecommendListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(" collection view indexPath : \(indexPath.item)")
        print(viewModel.item(at: indexPath.item))
    }
}

extension RecommendListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
}

class RecommendListViewModel {
    enum RecommendType {
        case award
        case hot
        case my
        
        var title: String {
            switch self {
            case .award: return "아카데미 호평 영화"
            case .hot: return "요즘 핫한 영화"
            case .my: return "내 취향 저격 영화"
            }
        }
    }
    
    private (set) var type: RecommendType = .my
    private var items: [DummyItem] = []
    
    var numOfItems: Int {
        return items.count
    }
    
    func item(at index: Int) -> DummyItem {
        return items[index]
    }
    
    func updateType(_ type: RecommendType) {
        self.type = type
    }
    
    func fetchItems() {
        self.items = MovieFetcher.fetch(type)
    }
}

class MovieFetcher {
    static func fetch(_ type: RecommendListViewModel.RecommendType) -> [DummyItem] {
        switch type {
        case .award:
            let movies = (1..<10).map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!)}
            return movies
        case .hot:
            let movies = (10..<19).map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!)}
            return movies
        case .my:
            let movies = (1..<10).map {$0 * 2}.map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!)}
            return movies
            
        }
    }
}


class RecommendCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    func updateUI(movie: DummyItem){
        thumbnailImage.image = movie.thumbnail
    }
}

struct DummyItem {
    let thumbnail: UIImage
}
