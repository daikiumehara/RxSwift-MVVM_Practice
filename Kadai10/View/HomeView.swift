//
//  ViewController.swift
//  Kadai10
//
//  Created by daiki umehara on 2021/09/10.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeView: UIViewController {
    @IBOutlet private var reloadButton: UIBarButtonItem!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var tableView: UITableView!

    private var prefectures: [String] = []
    private let disposeBag = DisposeBag()
    private let cellColors: [UIColor] = [#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)]
    private lazy var viewModel = HomeViewModel(
        didTapReloadObservable: reloadButton.rx.tap.asObservable(),
        model: PrefecturesModel()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()

        self.reloadButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.reloadButton.isEnabled = false
            })
            .disposed(by: disposeBag)

        viewModel.prefecturesObservable
            .subscribe(onNext: { [weak self] prefectures in
                DispatchQueue.main.async {
                    self?.prefectures = prefectures
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)

        viewModel.statusObservable
            .subscribe(onNext: { [weak self] status in
                DispatchQueue.main.async {
                    switch status {
                    case .idle, .success:
                        self?.activityIndicator.stopAnimating()
                        self?.reloadButton.isEnabled = true
                    case .loading:
                        self?.activityIndicator.startAnimating()
                    case .error:
                        self?.activityIndicator.stopAnimating()
                        self?.reloadButton.isEnabled = true
                        self?.makeAndPresentAlert()
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    private func configureTableView() {
        tableView.register(PrefectureViewCell.nib,
                           forCellReuseIdentifier: PrefectureViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func makeAndPresentAlert() {
        let alert = UIAlertController(title: "エラー", message: "エラーが発生しました",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}

extension HomeView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        prefectures.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrefectureViewCell.identifier) as? PrefectureViewCell else {
            fatalError("セルが見つかりませんでした")
        }
        cell.configure(name: prefectures[indexPath.row],
                       index: indexPath.row + 1,
                       color: cellColors[indexPath.row % 3])
        return cell
    }
}

