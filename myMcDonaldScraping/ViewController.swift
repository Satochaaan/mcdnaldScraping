//
//  ViewController.swift
//  myMcDonaldScraping
//
//  Created by 川野智史 on 2021/07/29.
//

import UIKit
import Alamofire
import Kanna

class ViewController: UIViewController,
                      UITableViewDelegate,
                      UITableViewDataSource{
    
    var burgerTableView = UITableView()
    var burgerList = [Burger]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // ダークモード解除
        overrideUserInterfaceStyle = .light
        // 背景色設定
        self.view.backgroundColor = UIColor.white
        
        // バーガーテーブル配置
        self.burgerTableView.delegate = self
        self.burgerTableView.dataSource = self
        self.burgerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.burgerTableView)
        self.burgerTableView.translatesAutoresizingMaskIntoConstraints = false
        self.burgerTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.burgerTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.burgerTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.burgerTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // スクレイピング実行
        self.getBurgerMenu()
    }
    
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.burgerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        let burger = self.burgerList[indexPath.row]
        cell.textLabel?.text = burger.name
        cell.detailTextLabel?.text = burger.price
        return cell
    }
    
    // MARK: - Function
    func getBurgerMenu() {
        AF.request("https://www.mcdonalds.co.jp/menu/burger/").responseString { response in
            switch response.result {
            case let .success(value):
                if let doc = try? HTML(html: value, encoding: .utf8) {
                    // バーガーの名前をXpathで指定
                    var names = [String]()
                    // start-withで前方一致検索
                    for link in doc.xpath("//strong[starts-with(@class,'product-list-card-name font-bold')]") {
                        print("name:" + (link.text ?? ""))
                        names.append(link.text ?? "")
                    }
                    
                    // バーガーのの値段をXpathで指定
                    var prices = [String]()
                    for link in doc.xpath("//span[starts-with(@class,'product-list-card-price-number')]") {
                        print("price:" + (link.text ?? ""))
                        prices.append(link.text ?? "")
                    }
                    
                    // バーガーの名前分だけループ
                    for (index, value) in names.enumerated() {
                        let burger = Burger()
                        burger.name = value
                        burger.price = prices[index]
                        self.burgerList.append(burger)
                    }
                    self.burgerTableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
