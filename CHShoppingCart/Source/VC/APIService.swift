//
//  APIService.swift
//  CHShoppingCart
//
//  Created by Chae_Haram on 2022/06/14.
//

import Foundation

struct APIService {
    let baseUrl: String = "https://openapi.naver.com/v1/search/shop.json?"

    func searchItem(query: String, completion: @escaping (ItemList?, Int) -> Void) {
        
        // 파라미터 처리
        var urlComponents = URLComponents(string: baseUrl)
        let queryItems = URLQueryItem(name: "query", value: query)
        urlComponents?.queryItems = [queryItems]
        
        // 헤더 처리
        guard let urlComponents = urlComponents , let url = urlComponents.url else { return }
        var requestUrl = URLRequest(url: url)
        requestUrl.addValue("OSU4vGNYP63hCp5W6GdY", forHTTPHeaderField: "X-Naver-Client-Id")
        requestUrl.addValue("6jux7MDaoA", forHTTPHeaderField: "X-Naver-Client-Secret")
        
        // 완성된 url을 바탕으로 통신 처리
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: requestUrl) { data, response, error in
            // 1. 들어온 옵셔널 데이터들을 언래핑 해주기
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            guard error == nil else {
                completion(nil, response.statusCode)
                return
            }
            
            // 2. data를 우리가 원하는 모델 형식으로 파싱하기.(decode)
            do {
                let decoder = JSONDecoder()
                let documents = try decoder.decode(ItemList.self, from: data)
                // 3-1. try catch문을 통해 파싱이 잘 되었으면 데이터를 넘겨준다.(try)
                completion(documents, response.statusCode)
            } catch {
                // 3-2. 아니면 에러를 잡아낸다.(catch)
                completion(nil, response.statusCode)
            }
        }
        dataTask.resume()
    }
}




