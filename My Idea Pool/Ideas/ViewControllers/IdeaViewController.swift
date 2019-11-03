//
//  IdeaViewController.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-29.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import UIKit

class IdeaViewController: UIViewController {
    
    @IBOutlet weak var emptyImage: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Class Varibles
    
    let reuseIdentifier = "IdeaCollectionViewCell" // also enter this string as the cell identifier in the storyboard
    
    var authenticationTokens: AuthenticationTokens! {
        didSet {
            print("Authentication tokens have been set.")
            UserDefaults.standard.removeObject(forKey: Constants.jwt.rawValue)
            UserDefaults.standard.removeObject(forKey: Constants.refresh_token.rawValue)
            UserDefaults.standard.set(self.authenticationTokens.jwt, forKey: Constants.jwt.rawValue)
            UserDefaults.standard.set(self.authenticationTokens.refresh_token, forKey: Constants.refresh_token.rawValue)
            print("Authentication tokens have been saved.")
        }
    }
    
    var ideas = [Idea]()  {
        didSet {
            DispatchQueue.main.async() {
                if self.ideas.count == 0 { self.emptyImage.isHidden = false }
                else { self.emptyImage.isHidden = true }
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - IB Outlets
    
    @IBAction func addNewIdea(_ sender: Any) {
        instatiateNewOrEditVC(index: nil)
    }
    
    //MARK: Navigation
    
    private func instatiateNewOrEditVC(index: Int?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addOrEditVC = storyboard.instantiateViewController(withIdentifier: "EditOrNewIdeaVC") as! AddIdeaViewController
        addOrEditVC.delegate = self
        if let indexCheck = index {
            addOrEditVC.indexOfIdeaToEdit = indexCheck
            addOrEditVC.ideaToEdit = self.ideas[indexCheck]
        }
        self.navigationController?.pushViewController(addOrEditVC, animated: true)
    }
    
    //MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setUpLogOutBtn()
        setUpCollectionView()
        configureNextVCBackBtn()
        
        guard let savedToken = UserDefaults.standard.string(forKey: Constants.jwt.rawValue) else { return }
        RESTApiManager.sharedInstance.makeAPICall(endPoint: Endpoints.getIdeas.rawValue, json: nil, requestType: "GET", authToken: savedToken, completion: handleIdeaDownloadResponse(data:error:))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //configureNextVCBackBtn()
        if let addIdeaVc = segue.destination as? AddIdeaViewController {
            addIdeaVc.delegate = self
        }
    }
    
    //MARK: - UI Setup
    
    private func configureNextVCBackBtn(){
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backItem
    }
    
    private func setUpLogOutBtn(){
        let logOutBtn = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutPressed))
        logOutBtn.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = logOutBtn
    }
    
    @objc private func logOutPressed(){
        
        guard let encodedRefreshToken = getEncodedTokens() else { return }
        guard let savedToken = UserDefaults.standard.string(forKey: Constants.refresh_token.rawValue) else { return }
        RESTApiManager.sharedInstance.makeAPICall(endPoint: Endpoints.logInOut.rawValue, json: encodedRefreshToken, requestType: "DELETE", authToken: savedToken,  completion: handleLoginResponse(data:error:))
    }

    private func setUpCollectionView(){
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(44)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 5, trailing: 15)
        section.interGroupSpacing = 15
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
    }
    
    //MARK: - Utility
    
    private func sortDataSource(this: Idea, that: Idea) -> Bool{
        return this.average_score > that.average_score
    }
    
    private func getEncodedTokens() -> Data? {
        guard let savedRefreshToken = UserDefaults.standard.string(forKey: Constants.refresh_token.rawValue) else { return nil }
        //guard let refreshToken = authenticationTokens.refresh_token else { fatalError() }
        let authTokens = AuthenticationTokens(refresh_token: savedRefreshToken)
        var encodedRefreshToken: Data!
        do { encodedRefreshToken = try JSONEncoder().encode(authTokens) }
        catch {
            PostAlerts.presentAlertController(viewController: self, titleMsg: "Encoding Error", errorMsg: error.localizedDescription)
            return nil
        }
        return encodedRefreshToken
    }
    
    //MARK: - Handle API Responses
    
    private func handleIdeaDownloadResponse(data: Data?, error: String?) {
        
        guard data != nil, error == nil else {
            DispatchQueue.main.async() { PostAlerts.presentAlertController(viewController: self, titleMsg: "Error", errorMsg: error!) }
            return
        }
        
//        let convertedString = String(data: data!, encoding: String.Encoding.utf8)
//        print(convertedString)
        
        var downdloadIdeas: [Idea]!
        do { downdloadIdeas = try JSONDecoder().decode([Idea].self, from: data!) }
        catch {
            PostAlerts.presentAlertController(viewController: self, titleMsg: "Error", errorMsg: error.localizedDescription)
        }
        downdloadIdeas.sort(by: self.sortDataSource(this:that:))
        ideas = downdloadIdeas
    }
    
    private func handleLoginResponse(data: Data?, error: String?) {
        
        guard data != nil, error == nil else {
            DispatchQueue.main.async() { PostAlerts.presentAlertController(viewController: self, titleMsg: "Error", errorMsg: error!) }
            return
        }

        DispatchQueue.main.async() {
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
                UserDefaults.standard.removeObject(forKey: Constants.jwt.rawValue)
                UserDefaults.standard.removeObject(forKey: Constants.refresh_token.rawValue)
            }
        }
    }
}

//MARK: - CollectionView Delegate
extension IdeaViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ideas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! IdeaCollectionViewCell
        cell.titleLabel.text = ideas[indexPath.row].content
        cell.impactValue.text = String(ideas[indexPath.row].impact)
        cell.easeValue.text = String(ideas[indexPath.row].ease)
        cell.confidenceValue.text = String(ideas[indexPath.row].confidence)
        cell.avgValue.text = String(ideas[indexPath.row].average_score)
        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(self.cellBtnTapped), for: .touchUpInside)
        
        return cell
    }
}
//MARK: - New Or Update Idea Delegate
extension IdeaViewController: NewIdeaCreatedDelegate {
    func passEditedIdea(idea: Idea, index: Int) {
        self.ideas.remove(at: index)
        self.ideas.insert(idea, at: index)
        self.ideas.sort(by: self.sortDataSource(this:that:))
        DispatchQueue.main.async() { self.collectionView.reloadData() }
    }
    
    
    func passNewIdea(idea: Idea) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.ideas.insert(idea, at: 0)
            self.ideas.sort(by: self.sortDataSource(this:that:))
            
            // This loop searches for the matching idea in the sorted datasource to find the insert index.
            for (index, findIdea) in self.ideas.enumerated() {
                if findIdea.content == idea.content {
                    let newIndexPath = IndexPath(item: index, section: 0)
                    self.collectionView.insertItems(at: [newIndexPath])
                }
            }
        }
    }
}

//MARK: - Cell Button Handling
extension IdeaViewController {
    
    @objc func cellBtnTapped(sender: UIButton) {
        
        let cellIndex = sender.tag
        guard let savedToken = UserDefaults.standard.string(forKey: Constants.jwt.rawValue) else { return }
        let alert = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction) in
            print("User click Edit button")
            self.instatiateNewOrEditVC(index: cellIndex)
        }))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction) in
            print("User click Delete button")
            let performDeleteAlert = self.getPerformDeleteAlert(savedToken: savedToken, cellIndex: cellIndex)
            self.present(performDeleteAlert, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func editIdea(){
        
    }
    
    private func getPerformDeleteAlert(savedToken: String, cellIndex: Int) -> UIAlertController{
        
        let alert = UIAlertController(title: "Are you sure?", message: "This idea will be permanently deleted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:{ (UIAlertAction) in
            print("User click Dismiss button")
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            let ideaId = self.ideas[cellIndex].id
            RESTApiManager.sharedInstance.makeAPICall(endPoint: Endpoints.removeOrEditIdea.rawValue + ideaId, json: nil, requestType: "DELETE", authToken: savedToken, completion: { (data: Data?, error: String?) in
                guard data != nil, error == nil else {
                    DispatchQueue.main.async() { PostAlerts.presentAlertController(viewController: self, titleMsg: "Error", errorMsg: error!) }
                    return
                }
                self.ideas.remove(at: cellIndex)
                let newIndexPath = IndexPath(item: cellIndex, section: 0)
                DispatchQueue.main.async() { self.collectionView.deleteItems(at: [newIndexPath]) }
            })
        }))
        return alert
    }
}
