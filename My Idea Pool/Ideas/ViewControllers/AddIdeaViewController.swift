//
//  AddIdeaViewController.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-29.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import UIKit

protocol NewIdeaCreatedDelegate {
    func passNewIdea(idea: Idea)
    func passEditedIdea(idea: Idea, index: Int)
}

class AddIdeaViewController: UIViewController {

    //MARK: - IB Outlets
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var impactValue: UILabel!
    @IBOutlet weak var easeValue: UILabel!
    @IBOutlet weak var confidenceValue: UILabel!
    @IBOutlet weak var avgValue: UILabel!
    @IBOutlet weak var contentMessage: UITextView!
    
    var pickerView: UIPickerView!
    var delegate: NewIdeaCreatedDelegate!
    var indexOfIdeaToEdit: Int!
    var ideaToEdit: Idea!
    let pickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBarAddEditIdea()
        addKeyboardListeners()
        contentMessage.delegate = self
        contentMessage.textColor = UIColor.darkGray
        if ideaToEdit != nil {
            configureUIWithIdeaToEdit(idea: ideaToEdit)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Keyboard
    
    private func addKeyboardListeners(){
        //Notifications for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(adjustScrollView), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustScrollView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustScrollView(notification: Notification){
        scrollView.adjustScrollViewForKeyboard(notification: notification, scrollView: self.scrollView, view: view.window!)
    }
    
    //MARK: - UI Config
    
    private func configureUIWithIdeaToEdit(idea: Idea){
        contentMessage.text = ideaToEdit.content
        impactValue.text = String(ideaToEdit.impact)
        easeValue.text = String(ideaToEdit.ease)
        confidenceValue.text = String(ideaToEdit.confidence)
        calculateNewAverage()
    }
    
    private func setImpactRatingHandler(alert: UIAlertAction!){
        let selectedValue = pickerData[pickerView.selectedRow(inComponent: 0)]
        impactValue.text = selectedValue
        calculateNewAverage()
    }
    
    private func setEaseRatingHandler(alert: UIAlertAction!){
        let selectedValue = pickerData[pickerView.selectedRow(inComponent: 0)]
        easeValue.text = selectedValue
        calculateNewAverage()
    }
    
    private func setConfidenceRatingHandler(alert: UIAlertAction!){
        let selectedValue = pickerData[pickerView.selectedRow(inComponent: 0)]
        confidenceValue.text = selectedValue
        calculateNewAverage()
    }
    
    //MARK: - IB Actions
    
    @IBAction func setImpactBtn(_ sender: Any) {
        showPicker(sender: "impactBtn")
    }
    
    @IBAction func setEaseBtn(_ sender: Any) {
        showPicker(sender: "easeBtn")
    }
    
    @IBAction func setConfidenceBtn(_ sender: Any) {
        showPicker(sender: "confidenceBtn")
    }
    
    @IBAction func cancelEntry(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        guard contentMessage.text != "Add your message here..." else {
            PostAlerts.presentAlertController(viewController: self, titleMsg: "Save Error", errorMsg: "Please enter a message.")
            return
        }
        self.saveBtn.isEnabled = false  // prevents multiple api calls
        
        let content = contentMessage.text
        let impact = impactValue.text
        let ease = easeValue.text
        let confidense = confidenceValue.text
        
        let idea = NewIdea(content: content!, impact: impact!, ease: ease!, confidence: confidense!)
        guard let data = encodeObjectToJSON(idea: idea) else { return }
        guard let savedToken = UserDefaults.standard.string(forKey: Constants.jwt.rawValue) else { return }
        
        if indexOfIdeaToEdit != nil && ideaToEdit != nil {
            let ideaId = self.ideaToEdit.id
            // Edit the idea
            RESTApiManager.sharedInstance.makeAPICall(endPoint: Endpoints.removeOrEditIdea.rawValue + ideaId, json: data, requestType: "PUT", authToken: savedToken, completion: handleApiResponse(data:error:))
        }
        else {
            // Create a new Idea
            RESTApiManager.sharedInstance.makeAPICall(endPoint: Endpoints.newIdea.rawValue, json: data, requestType: "POST", authToken: savedToken, completion: handleApiResponse(data:error:))
        }
    }
    
    //MARK: - Utility
    
    private func encodeObjectToJSON(idea: NewIdea) -> Data?{
        var encodedNewIdea: Data!
        let objectToEncode = idea
        do { encodedNewIdea = try JSONEncoder().encode(objectToEncode) }
        catch {
            PostAlerts.presentAlertController(viewController: self, titleMsg: "Encoding Error", errorMsg: error.localizedDescription)
            return nil
        }
        return encodedNewIdea
    }
    
    private func calculateNewAverage(){
        
        let impact = Int(impactValue.text!)
        let ease = Int(easeValue.text!)
        let confidence = Int(confidenceValue.text!)
        
        let avg = Double(impact! + ease! + confidence!)/3.0
        let avgRounded = avg.rounded(toPlaces: 2)
        avgValue.text = String(avgRounded)
    }
    
    //MARK: - UIPickerView
    
    private func showPicker(sender: String){
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Choose a Rating", message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        
        switch sender {
        case "impactBtn":
            editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: setImpactRatingHandler(alert:)))
        case "easeBtn":
            editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: setEaseRatingHandler(alert:)))
        case "confidenceBtn":
            editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: setConfidenceRatingHandler(alert:)))
        default:
            fatalError("Handler does not exist.")
        }
        
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
    //MARK: Handle API Response
    
    private func handleApiResponse(data: Data?, error: String?) {
        
        guard data != nil, error == nil else {
            self.saveBtn.isEnabled = true  // prevents multiple api calls
            DispatchQueue.main.async() { PostAlerts.presentAlertController(viewController: self, titleMsg: "Error", errorMsg: error!) }
            return
        }
        var theIdea: Idea!
        do { theIdea = try JSONDecoder().decode(Idea.self, from: data!) }
        catch {
            PostAlerts.presentAlertController(viewController: self, titleMsg: "Error", errorMsg: error.localizedDescription)
        }
        
        if indexOfIdeaToEdit != nil && ideaToEdit != nil{
            delegate.passEditedIdea(idea: theIdea, index: indexOfIdeaToEdit)
        } else {
            delegate.passNewIdea(idea: theIdea)
        }
        
        DispatchQueue.main.async() {
            
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }
    }
    
}

//MARK: - PickerView Delegate and DataSource
extension AddIdeaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}

//MARK: - TextView Delegate
extension AddIdeaViewController : UITextViewDelegate{

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "Add your message here..."
            textView.textColor = UIColor.darkGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.darkGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
        // For every other case, the text should change with the usual
        // behavior...
        else {
            return textView.text.count + (text.count - range.length) <= 200
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let newPosition = textView.beginningOfDocument
        textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
    }
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.darkGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
