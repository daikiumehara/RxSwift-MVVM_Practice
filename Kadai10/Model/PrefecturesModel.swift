//
//  PrefecturesModel.swift
//  Kadai10
//
//  Created by daiki umehara on 2021/09/10.
//

import Foundation
import RxSwift
import RxCocoa

protocol PrefecturesModelProtocol {
    func getPrefectures() -> Event<[String]>
}

class PrefecturesModel: PrefecturesModelProtocol {
    func getPrefectures() -> Event<[String]> {
        return PrefecturesClient().fetchDatas()
    }
}
