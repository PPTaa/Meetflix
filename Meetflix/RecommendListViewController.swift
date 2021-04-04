//
//  RecommendListViewController.swift
//  Meetflix
//
//  Created by leejungchul on 2021/04/04.
//

import Foundation
import UIKit

class RecommendListViewController: UIViewController {
    
    
    @IBOutlet weak var sectionTitle: UILabel!
    let viewModel = RecommendListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func updateUI() {
    }
}

extension RecommendListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell else { return UICollectionViewCell() }
        let movie = viewModel.item(at: indexPath.item)
        cell.updateUI(movie: movie)
        return cell
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
}


class RecommendCell: UICollectionViewCell {
    
}
