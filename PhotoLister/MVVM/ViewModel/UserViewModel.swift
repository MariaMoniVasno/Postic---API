//
//  UserViewModel.swift
//  PhotoLister
//
//  Created by Trident on 02/11/22.
//

import Foundation
import Combine

class UserViewModel {
    
    // Fetching the Whole User list and storing in UserDetailModel class
    func getWholeUsersList(completion:@escaping ([UserDetailModel]) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                let userList = try! JSONDecoder().decode([UserDetailModel].self, from: data)
                DispatchQueue.main.async {
                    completion(userList)
                }
            }
        }
        .resume()
    }
    
    // Fetching the User Post list and storing in UserPostModel class
    func getUserPost(id : Int ,completion:@escaping ([UserPostModel]) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(id)/posts") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
            let userPost = try! JSONDecoder().decode([UserPostModel].self, from: data)
            DispatchQueue.main.async {
                completion(userPost)
            }
            }
        }
        .resume()
    }
    
    // Fetching the User Post comments for individual post and storing in UserPostCommentsModel class
    func getUserPostComments(id : Int ,completion:@escaping ([UserPostCommentsModel]) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(id)/comments") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
            let comments = try! JSONDecoder().decode([UserPostCommentsModel].self, from: data)
//            print(comments)
            
            DispatchQueue.main.async {
                completion(comments)
            }
            }
        }
        .resume()
    }
    
    // Fetching the User Photo and storing in UserPhotoModel class
    func getUserPhoto(completion:@escaping ([UserPhotoModel]) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/albums/1/photos") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
            let userPhoto = try! JSONDecoder().decode([UserPhotoModel].self, from: data)
            DispatchQueue.main.async {
                completion(userPhoto)
            }
            }
        }
        .resume()
    }
    
    
    // Fetching the random number between 1 to 20
    func makeList(_ n: Int) -> [Int] {
        return (0..<n).map { _ in .random(in: 1...20) }
    }
}

  // UpdaterViewModel to show the timer for the last refresh in comments.

class UpdaterViewModel: ObservableObject {
    @Published var now: Date = Date()
    @Published var timeStr: String = EmptyStr

    
    var timer: Timer?
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.refresh()
        })
    }
    deinit {
        timer?.invalidate()
    }
    func refresh() {
        timeStr  = (UserDefaultsStore.saveRefreshDate?.timeAgoDisplay().contains("in") == true) || (UserDefaultsStore.saveRefreshDate?.timeAgoDisplay().contains("minute") == true) ? UserDefaultsStore.saveRefreshDate?.timeAgoDisplay() ?? EmptyStr : AFewSecondsAgo
    }
}
