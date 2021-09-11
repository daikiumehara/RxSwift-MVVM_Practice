//
//  HomeViewModel.swift
//  Kadai10
//
//  Created by daiki umehara on 2021/09/10.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    private var status = PublishSubject<Status>()
    var statusObservable: Observable<Status> {
        status.asObservable()
    }
    private var prefectures = PublishSubject<[String]>()
    var prefecturesObservable: Observable<[String]> {
        prefectures.asObservable()
    }
    private let disposeBag = DisposeBag()
    private let model: PrefecturesModelProtocol
    
    init(didTapReloadObservable: Observable<Void>, model: PrefecturesModelProtocol) {
        self.model = model

        didTapReloadObservable
            .subscribe(onNext: { [weak self] in
                self?.status.onNext(.loading)
                DispatchQueue.global().async {
                    let event = model.getPrefectures()
                    switch event {
                    case .next(let prefectures):
                        self?.status.onNext(.success)
                        self?.prefectures.onNext(prefectures)
                    case .error:
                        self?.status.onNext(.error)
                    case .completed:
                        break
                    }
                }
            })
            .disposed(by: disposeBag)

        self.status.onNext(.idle)

        self.status
            .disposed(by: disposeBag)
        self.prefectures
            .disposed(by: disposeBag)
    }
}

enum Status {
    case idle
    case loading
    case error
    case success
}
