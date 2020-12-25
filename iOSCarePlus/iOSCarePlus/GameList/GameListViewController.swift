//
//  GameListViewController.swift
//  iOSCarePlus
//
//  Created by 최원석 on 2020/12/16.
//

import UIKit
import Alamofire

class GameListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var newGameListURL: String {
        "https://ec.nintendo.com/api/KR/ko/search/new?count=\(newCount)&offset=\(newOffset)"
    }
    private var newCount: Int = 10
    private var newOffset: Int = 0
    private var isEnd: Bool = false
    private var model: NewGameResponse? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        tableView.register(GameItemCodeTableViewCell.self, forCellReuseIdentifier: "GameItemCodeTableViewCell")
        setTableViewDefault()
        newGameListApiCall()
    }
    
    private func setTableViewDefault() {
        tableView.tableFooterView = UIView()
    }
    
    private func newGameListApiCall() {
        AF.request(newGameListURL).responseJSON { [weak self] response in
            guard let data = response.data else { return }
            let decoder = JSONDecoder()
            guard let model = try? decoder.decode(NewGameResponse.self, from: data) else { return }
            if self?.model == nil {
                self?.model = model
                self?.tableView.tableFooterView = nil
            } else {
                if model.contents.isEmpty {
                    self?.isEnd = true
                }
                self?.model?.contents.append(contentsOf: model.contents)
            }
            //            self.tableView.reloadData()
        }
    }
}

extension GameListViewController: UITableViewDelegate {
}

extension GameListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEnd {
            return (model?.contents.count ?? 0)
        }
        return (model?.contents.count ?? 0) + 1
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "GameItemCodeTableViewCell", for: indexPath)
    //        return cell
    //    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isIndicatorCell(indexPath) {
            newOffset += 10
            newGameListApiCall()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isIndicatorCell(indexPath) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IndicatorCell") as? IndicatorCell else {
                return UITableViewCell()
            }
            cell.animationIndicatorView()
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameItemTableViewCell", for: indexPath) as? GameItemTableViewCell  else {
            return UITableViewCell()
        }
        
        guard let content = model?.contents[indexPath.row] else {
            return UITableViewCell()
        }
        
        let model = GameItemModel(gameTitle: content.formalName, gameOriginPrice: 10000, gameDiscountPrice: nil, imaegeURL: content.heroBannerURL)
        cell.setModel(model)
        return cell
    }
    
    private func isIndicatorCell(_ indexPath: IndexPath) -> Bool {
        indexPath.row == model?.contents.count
    }
}

