//
//  NewTaskViewController.swift
//  TaskList
//
//  Created by Goodwasp on 21.09.2023.
//

import UIKit
import CoreData // TODO: - remove

final class NewTaskViewController: UIViewController {

    // MARK: - Public properties
    var delegate: TaskViewControllerDelegate!
    
    // MARK: - Private properties
    
    // TODO: - remove
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let taskTF = UITextField()
    private let saveButton = UIButton()
    private let cancelButton = UIButton()
    
    // MARK: View's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - Actions
    @objc
    private func saveButtonPressed() {
        saveTask()
        delegate.reloadData()
        dismiss(animated: true)
    }
    
    @objc
    private func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    private func saveTask() {
        let task = Task(context: viewContext)
        task.title = taskTF.text
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Settings view
extension NewTaskViewController {
    private func setupView() {
        view.backgroundColor = .white
        setupTextField()
        setupSaveButton()
        setupCancelButton()
        addSubViews()
        setupLayout()
        addActions()
    }
}

// MARK: - Settings
extension NewTaskViewController {
    
    private func addSubViews() {
        [
            taskTF,
            saveButton,
            cancelButton
        ].forEach { subView in
            view.addSubview(subView)
        }
    }
    
    private func setupTextField() {
        taskTF.placeholder = "New Task"
        taskTF.borderStyle = .roundedRect
        taskTF.backgroundColor = .lightGray
    }
    
    private func setupSaveButton() {
        saveButton.setTitle("Save Task", for: .normal)
        saveButton.layer.backgroundColor = UIColor(named: "MilkPink")?.cgColor
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        saveButton.layer.cornerRadius = 5
    }
    
    private func setupCancelButton() {
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
    }
    
    private func addActions() {
        saveButton.addTarget(
            self,
            action: #selector(saveButtonPressed),
            for: .touchUpInside
        )
        cancelButton.addTarget(
            self,
            action: #selector(cancelButtonPressed),
            for: .touchUpInside
        )
    }
}

// MARK: - Layout
extension NewTaskViewController {
    private func setupLayout() {
        [
            taskTF,
            saveButton,
            cancelButton
        ].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            taskTF.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 60
            ),
            taskTF.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            taskTF.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            
            saveButton.topAnchor.constraint(
                equalTo: taskTF.bottomAnchor,
                constant: 30
            ),
            saveButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -40
            ),
            saveButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 40
            ),
            
            cancelButton.topAnchor.constraint(
                equalTo: saveButton.bottomAnchor,
                constant: 30
            ),
            cancelButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -40
            ),
            cancelButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 40
            )
        ])
    }
}
