//
//  HomeViewController.swift
//  Meetflix
//
//  Created by leejungchul on 2021/03/24.
//

import Foundation
import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewOne.dataSource = self
        collectionViewTwo.dataSource = self
        
        SearchAPI.search("avengers") { movie in
            self.movieOne = movie
        }
        SearchAPI.search("interstellar") { movie in
            self.movieTwo = movie
        }
    }
    
    @IBOutlet weak var collectionViewOne: UICollectionView! 
    @IBOutlet weak var collectionViewTwo: UICollectionView!
    
    var movieOne: [Movie] = []
    var movieTwo: [Movie] = []
    
    @IBAction func moreInfo(_ sender: Any) {
        print("click more btn")
    }
    @IBAction func playMovie(_ sender: Any) {
        print("click playMovie btn")
        SearchAPI.search("interstellar") { movie in
            DispatchQueue.main.async {
                
                let url = URL(string: movie.first!.previewURL)!
                let item = AVPlayerItem(url: url)
                
                let sb = UIStoryboard(name: "Player", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
                
                vc.modalPresentationStyle = .fullScreen
                
                vc.player.replaceCurrentItem(with: item)
                
                self.present(vc, animated: false, completion: nil)
                
            }
        }
    }
    @IBAction func information(_ sender: Any) {
        print("click information btn")
        print(movieOne)
        print(movieTwo)
    }
    
}

extension HomeViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewOne {
            return movieOne.count
        }
        if collectionView == collectionViewTwo {
            return movieTwo.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "oneCell", for: indexPath)
        if collectionView == collectionViewOne {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "oneCell", for: indexPath) as? CellOne else { return UICollectionViewCell() }
            let movie = movieOne[indexPath.item]
            cell.title.text = movie.title
            return cell
        }
        if collectionView == collectionViewTwo {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "oneCell", for: indexPath) as? CellTwo else { return UICollectionViewCell() }
            let movie = movieTwo[indexPath.item]
            cell.title.text = movie.title
            return cell
        }
        return cell
        
    }
    
    
}
extension HomeViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Click Item : \(indexPath.item)")
    }
}

class CellOne: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    
}
class CellTwo: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    
}
