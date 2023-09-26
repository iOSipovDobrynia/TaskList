//
//  TaskListViewController.swift
//  TaskList
//
//  Created by Goodwasp on 20.09.2023.
//

import UIKit

final class TaskListViewController: UITableViewController {

    // MARK: - Private properties
    private let cellID = "task"
    private var taskList: [Task] = []
    
    private let storageManager = StorageManager.shared
    
    // MARK: - View's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        fetchData()
    }
    
    // MARK: - Private func
    private func setupNavigationBar() {
        title = "Task list"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarApperance = UINavigationBarAppearance()
        navBarApperance.backgroundColor = UIColor(named: "MilkPink")
        navBarApperance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarApperance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc
    private func addNewTask() {
        showAlert(withTitle: "New task", andMessage: "input your task name")
    }
    
    private func create(_ taskName: String) {
        storageManager.create(taskName) { task in
            taskList.append(task)
            let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
            tableView.insertRows(at: [cellIndex], with: .automatic)
        }
    }
    
    private func fetchData() {
        storageManager.fetchData { result in
            switch result {
            case .success(let tasks):
                taskList = tasks
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func update(to newTaskName: String, at indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        storageManager.update(task: task, with: newTaskName)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            storageManager.delete(taskList[indexPath.row])
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.saveContext()
        }
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = taskList[indexPath.row]
        showAlert(withTitle: "Task", andMessage: "Change your task name", oldTask: selectedTask, at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UIAlertController
extension TaskListViewController {
    private func showAlert(withTitle title: String, andMessage message: String, oldTask: Task? = nil, at indexPath: IndexPath? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            guard let taskName = alert.textFields?.first?.text, !taskName.isEmpty else { return }
            
            if let _ = oldTask, let indexPath = indexPath {
                self?.update(to: taskName, at: indexPath)
            } else {
                self?.create(taskName)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            textField.placeholder = "New task"
            
            guard let task = oldTask else { return }
            textField.text = task.title
        }
        
        present(alert, animated: true)
    }
}
