//
//  EntryDetailViewController.swift
//  JournalCloudKit2
//
//  Created by Jason Goodney on 9/22/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry?
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        textField.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        textView.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        textView.delegate = self
        return textView
    }()
    
    lazy var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    
    convenience init(entry: Entry) {
        self.init(nibName: nil, bundle: nil)
        
        self.entry = entry
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Entry"
        hideKeyboardOnTap()
        updateView()
        updateText()
        textDidChange()
    }
    
    func updateView() {
        view.addSubview(titleTextField)
        view.addSubview(bodyTextView)
        
        titleTextField.anchor(view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, topConstant: 88, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 44)
        
        bodyTextView.anchor(titleTextField.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 164, rightConstant: 32, widthConstant: 0, heightConstant: 0)
        
        navigationItem.rightBarButtonItem = saveButton
        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    }
    
    func updateText() {
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
        title = entry.title
    }
    
    @objc func saveButtonTapped() {
        guard let title = titleTextField.text, let body = bodyTextView.text else { return }
        
        EntryController.shared.addEntry(withTitle: title, body: body) { (success) in
            if success {
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange() {
        if titleTextField.text!.isEmpty && bodyTextView.text.isEmpty {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
}

// MARK: - UITextViewDelegate
extension EntryDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textDidChange()
    }
}

// MARK: - Hide Keyboard Tap Gesture
extension UIViewController {
    func hideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
