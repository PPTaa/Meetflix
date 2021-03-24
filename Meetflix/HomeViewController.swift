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
    }
    
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
    }
    
}
