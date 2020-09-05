//
//  BaseViewModel.swift
//  Moment_Plan
//
//  Created by 박진 on 2020/08/22.
//  Copyright © 2020 kr.hs.dgsw.momentplan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    let disposeBag = DisposeBag()
    
    let isSuccess = BehaviorRelay(value: false)
    let isError = BehaviorRelay(value: false)
    let isLoading = BehaviorRelay(value: false)
}
