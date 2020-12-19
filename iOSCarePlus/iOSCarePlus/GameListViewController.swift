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
    let newGameListURL = "https://ec.nintendo.com/api/KR/ko/search/new?count=30&offset=0"
    var model: NewGameResponse? {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        newGameListApiCall()
    }
    private func newGameListApiCall() {
        AF.request(newGameListURL).responseJSON { [weak self] response in
            guard let data = response.data else { return }
            let decoder = JSONDecoder()
            let model = try? decoder.decode(NewGameResponse.self, from: data)
            self?.model = model
            //            self.tableView.reloadData()
        }
    }
}

extension GameListViewController: UITableViewDelegate {
}

extension GameListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.contents.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let content = model?.contents[indexPath.row] else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameItemTableViewCell", for: indexPath) as? GameItemTableViewCell  else {
            return UITableViewCell()
        }
        let model = GameItemModel(gameTitle: content.formalName, gameOriginPrice: 10000, gameDiscountPrice: nil, imaegeURL: content.heroBannerURL)
        cell.setModel(model)
        return cell
    }
}
