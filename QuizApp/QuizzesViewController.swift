//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by five on 13.04.2021..
//

import UIKit
import SnapKit

class QuizzesViewController: UIViewController {
    
    let cellIdentifier = "cellId"
    
    var loadButton: UIButton!
    var factLabel: UILabel!
    var factText: UILabel!
    var tableView: UITableView!
    
    var dataService = DataService()
    var quizzes: [String: [Quiz]] = Dictionary()
    var categories: [QuizCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        defineLayoutForViews()
        styleView()
    }
    
    private func defineLayoutForViews() {
        loadButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        factLabel.snp.makeConstraints {
            $0.top.equalTo(loadButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        factText.snp.makeConstraints {
            $0.top.equalTo(factLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(factText.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        
        
        
    }
    
    private func buildView() {
        loadButton = UIButton()
        view.addSubview(loadButton)
        loadButton.setTitle("Get Quiz", for: .normal)
        loadButton.addTarget(self, action: #selector(loadQuizzes), for: .touchUpInside)
        
        factLabel = UILabel()
        factLabel.text = "Fun Fact"
        factLabel.font = factLabel.font.withSize(30)
        view.addSubview(factLabel)
        
        factText = UILabel()
        factText.numberOfLines = 4
        view.addSubview(factText)
                
        tableView = UITableView(frame:CGRect(
                                            x: 0,
                                            y: 0,
                                            width: view.bounds.width,
                                            height: view.bounds.height))
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func loadQuizzes() {
        let quizArray = dataService.fetchQuizes()
        quizzes = Dictionary()
        
        for quiz in quizArray {
            if quizzes[quiz.category.rawValue] == nil {
                quizzes[quiz.category.rawValue] = Array()
            }
            quizzes[quiz.category.rawValue]?.append(quiz)
        }

        categories = Array(Set(quizArray.map({$0.category}))).sorted(by: {$0.rawValue > $1.rawValue})
        
        let factNumber = quizArray
            .flatMap { $0.questions }
            .map { $0.question }
            .filter { $0.contains("NBA")}
            .count
        
        factText.text = "There are " + String(factNumber) + " questions that contain the word \"NBA\""
        
        tableView.reloadData()
    }
    
    private func styleView() {
        view.backgroundColor = .systemBlue
        
        loadButton.backgroundColor = .white
        loadButton.setTitleColor(.systemBlue, for: .normal)
        
        tableView.backgroundColor = .systemBlue
    }
}

extension QuizzesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quizzes[categories[section].rawValue]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath)
        //cell.backgroundColor = UIColor(hue: 0.5, saturation: 0.5, brightness: 1.0, alpha: 0.7)
        let data = quizzes[categories[indexPath.section].rawValue]?[indexPath.row]

        let image = UIImage(systemName: "questionmark.square.fill")
                
        var cellConfig: UIListContentConfiguration = cell.defaultContentConfiguration()
        cellConfig.text = data?.title
        cellConfig.image = image
        var desc = data?.description ?? " "
        desc += " " + String(data?.level ?? 0) + "/3"

        cellConfig.secondaryText = desc
        cellConfig.secondaryTextProperties.numberOfLines = 2
    
        cell.contentConfiguration = cellConfig
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        quizzes.keys.count
        
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        categories[section].rawValue.uppercased()
    }
    
}

extension QuizzesViewController: UITableViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Logic when cell is selected
    }
}

class QuizCell: UITableViewCell {
    var quizDescription: UILabel!
    var quizImage: UIImageView!
    var quizDifficulty: UILabel!
    
    
    init(quiz: Quiz) {
        quizDescription = UILabel()
        quizImage = UIImageView()
        quizDifficulty = UILabel()
        
        quizDescription.text = quiz.description
        quizDifficulty.text = String(quiz.level) + "/5"
        
        super.init(style: .default, reuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
