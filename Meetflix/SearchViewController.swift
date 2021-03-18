//
//  SearchViewController.swift
//  Meetflix
//
//  Created by leejungchul on 2021/03/18.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
        // > 검색 API 필요
        // > 검색 결과를 받아올 모델 Movie, Response
        // > 결과를 받아와서 CollectionView 로 표현
        
        SearchAPI.search(searchTerm) { movies in
            // collectionView로 표현하기
        }
        
        print("검색어 : \(searchBar.text!)")
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
        urlComponents.queryItems?.append(mediaQuery)
        urlComponents.queryItems?.append(entityQuery)
        urlComponents.queryItems?.append(termQuery)
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
//            let text = String(data: resultData, encoding: .utf8)
//            print("String : \(text)")
//            completion([Movie])
        }
        dataTask.resume()
        
    }
}

struct Movie {
    
}

struct Response {
    
}
