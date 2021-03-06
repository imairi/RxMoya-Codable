//
//  ViewController.swift
//  RxMoya+Codable
//
//  Created by Imairi Yosuke on 2017/09/10.
//  Copyright © 2017年 Imairi Yosuke. All rights reserved.
//

import UIKit
import RxMoya
import Moya
import RxSwift
import RxCocoa
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    var viewModel: ViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let input = ViewModel.Input(tapButton: button.rx.tap.asObservable())
        viewModel = ViewModel(input: input)
        
        viewModel.didFinishGetUsers
            .subscribe(onNext: { users in
                print(users)
            }, onError: { (error) in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
