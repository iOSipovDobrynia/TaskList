//
//  NewTaskViewController.swift
//  TaskList
//
//  Created by Goodwasp on 21.09.2023.
//

import UIKit

class NewTaskViewController: UIViewController {

    // MARK: - Private properties
    private var taskTF = UITextField()
    
    // MARK: View's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}

// MARK: - Settings view
extension NewTaskViewController {
    private func setupView() {
        view.backgroundColor = .white
        setupTextField()
        addSubViews()
    }
}

// MARK: - Settings
extension NewTaskViewController {
    
    private func addSubViews() {
        [
        
        ].forEach { subView in
            view.addSubview(subView)
        }
    }
    
    private func setupTextField() {
        taskTF.placeholder = "New Task"
        taskTF.borderStyle = .roundedRect
    }
}
