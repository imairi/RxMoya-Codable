//
//  ViewModel.swift
//  RxMoya+Codable
//
//  Created by Imairi Yosuke on 2017/09/11.
//  Copyright © 2017年 Imairi Yosuke. All rights reserved.
//

import UIKit
import Moya
import RxMoya
import RxSwift
import RxCocoa

class ViewModel {
    struct Input {
        let tapButton: Observable<Void>
    }
    
    let didFinishGetUsers: Observable<[User]>
    
    fileprivate let provider: MoyaProvider<UserAPI> = {
        let stubClosure = { (target: UserAPI) -> StubBehavior in
            return .immediate
        }
        let networkLoggerPlugin = NetworkLoggerPlugin(cURL: true)
        let plugins = [networkLoggerPlugin]
        return MoyaProvider<UserAPI>(stubClosure: stubClosure, plugins: plugins)
    }()
    
    private let disposeBag = DisposeBag()
    
    init(input: Input) {
        let didFinishGetUsersSubject = PublishSubject<[User]>()
        
        didFinishGetUsers = didFinishGetUsersSubject.asObservable()
        
        input.tapButton
            .flatMap { self.provider.rx.request(UserAPI.fetch) }
            .subscribe(onNext: { (response) in
                do {
                    let decoder = JSONDecoder()
                    let users = try decoder.decode([User].self, from: response.data)
                    didFinishGetUsersSubject.onNext(users)
                } catch(let error) {
                    didFinishGetUsersSubject.onError(error)
                }
            }, onError: { (error) in
                didFinishGetUsersSubject.onError(error)
            })
            .disposed(by: disposeBag)
    }
}
