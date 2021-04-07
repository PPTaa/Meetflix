//
//  SearchViewController.swift
//  Meetflix
//
//  Created by leejungchul on 2021/03/18.
//

import UIKit
import Kingfisher
import AVFoundation
import Firebase

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    var movies: [Movie] = []
    var ref: DatabaseReference! = Database.database().reference()
    var searchCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
// 데이터
extension SearchViewController: UICollectionViewDataSource {
    // 몇개 넘어옴?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    // 어떻게 표현?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as? ResultCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.item]
        print("movie.thumbnailPath : \(movie.thumbnailPath)")
        // imagePath(string) -> Image
        // 외부 라이브러리 가져다 쓰기 방법 -> SPM, Cocoapod, Carthage
        // SPM 사용법 : File > Swift Packages > Add Package Dependency > Git URL
        // kingfisher 사용
        let thumbnailURL = URL(string: movie.thumbnailPath)
        cell.movieThumbnail.kf.setImage(with: thumbnailURL)
        
//        cell.backgroundColor = .green
        return cell
    }
}
// 클릭시 처리
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // movie item
        let movie = movies[indexPath.item]
        // 영상 item
        let url = URL(string: movie.previewURL)!
        let item = AVPlayerItem(url: url)
        
        print("click : \(movie.title)")
        // playerVC 제작
        // playerVC + Movie
        // PlayerVC 보여주기
        
        let sb = UIStoryboard(name: "Player", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        //모달창 말고 새창으로 뜨게 하는 부분
        vc.modalPresentationStyle = .fullScreen
        
        vc.player.replaceCurrentItem(with: item)
        
        present(vc, animated: false, completion: nil)
    }
    
}
// 컬렉션뷰 크기 조정
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 8
        let itemSpacing: CGFloat = 10
        let width = (collectionView.bounds.width - margin * 2 - itemSpacing * 2) / 3
        let height = width * 10 / 7
        return CGSize(width: width, height: height)
    }
}
// 컬렉션 뷰 셀 제작
class ResultCell: UICollectionViewCell {
    @IBOutlet weak var movieThumbnail: UIImageView!
}



extension SearchViewController: UISearchBarDelegate {
    //키보드 내려가게 하는 메소드
    private func dismissKeyboard(){
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 버튼 클릭 시작
        
        // 키보드가 올라와있을때 내려가도록 처리
        dismissKeyboard()
        // 검색어가 있는지
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        // 네트워킹을 통한 검색
        // > searchTerm을 통해 네트워킹을 해서 영화 검색
        // > 검색 API 필요 > SearchAPI
        // > 검색 결과를 받아올 모델 Movie, Response > struct 구성
        // > 결과를 받아와서 CollectionView 로 표현
        print("searchTerm : \(searchTerm)")
        SearchAPI.search(searchTerm) { movies in
            // collectionView로 표현하기
            print("count data : \(movies.count)")
            print("data title : \(movies.first?.title)")
            let timestamp: Double = Date().timeIntervalSince1970.rounded()
            self.ref.child("searchLog").childByAutoId().setValue(["searchText" : searchTerm, "timeStamp":timestamp])
//            이곳은 main thread가 아니기 때문에 뷰를 리로딩 하는 것은 메인에서 해야하만 에러가 나지 않음
//            self.movies = movies
//            self.resultCollectionView.reloadData()
            DispatchQueue.main.async {
                self.movies = movies
                self.resultCollectionView.reloadData()
            }
        }
        
        print("검색어 : \(searchBar.text!)")
        
//        self.ref.child("searchLog").setValue(searchBar.text!, forKey: "aaa")

    }
}

class SearchAPI {
    static func search(_ term: String, completion: @escaping ([Movie])->Void) {
        let session = URLSession(configuration: .default)
        
        //url 제작
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entityQuery = URLQueryItem(name: "entity", value: "movie")
        let termQuery = URLQueryItem(name: "term", value: term)
        let limitQuery = URLQueryItem(name: "limit", value: "200")
        urlComponents.queryItems?.append(mediaQuery)
        urlComponents.queryItems?.append(entityQuery)
        urlComponents.queryItems?.append(termQuery)
        urlComponents.queryItems?.append(limitQuery)
        let requestURL = urlComponents.url!
        
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            let successRange = 200..<300
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                completion([])
                return
                
            }
            guard let resultData = data else {
                completion([])
                return
            }
            // 확인코드
            let text = String(data: resultData, encoding: .utf8)
            
            let movies = SearchAPI.parseData(resultData)
            completion(movies)
//            print("String : \(text)")
//            completion([Movie])
        }
        dataTask.resume()
    }
    
    static func parseData(_ data: Data) -> [Movie] {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            let movies = response.movies
            return movies
        } catch let error {
            print("parse error : \(error.localizedDescription)")
            return []
        }
    }
}

struct Movie: Codable {
    let title: String
    let director: String
    let thumbnailPath: String
    let previewURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case director = "artistName"
        case thumbnailPath = "artworkUrl100"
        case previewURL = "previewUrl"
    }
    
}

struct Response: Codable {
    let resultCount: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case movies = "results"
    }
    
    
}
