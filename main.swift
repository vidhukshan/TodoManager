// mkdir TodoManager -> Makes a new folder called TodoManager
// cd TodoManager -> Moves you into that folder
// swift package init --name TodoManager --type executable: Creates a new Swift Package Manager project that will run as a command-line tool.

// TodoManager/
// ├── Package.swift         # Project configuration
// ├── Sources/
// │   └── TodoManager/
// │       └── main.swift    # Main code entry point
// └── Tests/                # For tests (not used yet)

// -Features to plan:

// --Add tasks
// --List all tasks
// --Delete tasks
// --Mark tasks as complete

import Foundation

struct TodoItem {
    var id: Int
    var title: String
    var isComplete: Bool
}

var todos: [TodoItem] = []

while true {
    print("\nTodo Manager")
    print("1. Add Task")
    print("2. List Tasks")
    print("3. Delete Task")
    print("4. Mark Task as Complete")
    print("5. Exit")
    print("Choose an option: ")


    if let input = readLine(), let choice = Int(input) {
        switch choice {
        case 1:
            //Add task 
            print("Enter task title: ")
            if let title = readLine() {
                let newId = todos.count + 1
                todos.append(TodoItem(id: newId, title: title, isComplete: false))
                print("Task Added")
            }
        case 2:
            //List tasks
            for todo in todos {
                print("\(todo.id). [\(todo.isComplete ? "✓" : " ")] \(todo.title)")
            }
        case 3:
            // Show all tasks so the user knows which to delete
            for todo in todos {
                print("\(todo.id). [\(todo.isComplete ? "✓" : " ")] \(todo.title)")
            }
            print("Enter the ID of the task to delete: ")
            if let input = readLine(), let idToDelete = Int(input) {
                // Find the index of the task with given ID
                if let index = todos.firstIndex(where: { $0.id == idToDelete }) {
                    todos.remove(at: index)
                    print("Task deleted!!!")
                } else {
                    print("Task with ID \(idToDelete) not found !")
                }
            } else {
                print("Invalid Input")
            }
        case 4:
            // Show all tasks so the user knows which to mark as complete
            for todo in todos {
                print("\(todo.id). [\(todo.isComplete ? "✓" : " ")] \(todo.title)")
            }
            print("Enter the ID of the task to mark it as complete")
            if let input = readLine(), let idToMark = Int(input) {
                // Find and update the task's completion date
                if let index = todos.firstIndex(where: { $0.id == idToMark }) {
                    todos[index].isComplete = true
                    print("Task marked as completed!")
                } else {
                    print("Task with ID \(idToMark) not found !")
                }
            } else {
                print("Invalid Input")
            }
        case 5:
            print("Goodbye")
            exit(0)
        default:
            print("Invaild option")
        }
    } else {
        print("Invalid input")
    }
}