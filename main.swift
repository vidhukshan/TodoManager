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

struct TodoItem: Codable {
    var id: Int
    var title: String
    var isComplete: Bool
}

var todos: [TodoItem] = []

//Define the path for ou JSON File
let fileURL = URL(fileURLWithPath: "todos.json")

//Functions to save tasks to the file
@MainActor
func saveTasks() {
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Makes the JSON File human readable
        let data = try encoder.encode(todos)
        try data.write(to: fileURL, options: .atomic)
    } catch {
        print("Error saving tasks: \(error.localizedDescription)")
    }
}

//Functions to load tasks from the file
@MainActor
func loadTasks() {
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        todos = try decoder.decode([TodoItem].self, from: data)
    } catch {
        // If the file doesn't exist or there's an error, just start with an empty list.
        // This is expected on the first run.
        print("No saved tasks found. Starting fresh.")
    }
}

func displayTask(_ todo: TodoItem) {
    print("\(todo.id). [\(todo.isComplete ? "✓" : " ")] \(todo.title)")
}

//Load existing tasks form the file when the app launches
loadTasks()

while true {
    print("\nTodo Manager")
    print("1. Add Task")
    print("2. List Tasks")
    print("3. Delete Task")
    print("4. Mark Task as Complete")
    print("5. Search Task by Title")
    print("6. Filter tasks by Completion")
    print("7. Exit")
    print("Choose an option: ")


    if let input = readLine(), let choice = Int(input) {
        switch choice {
        case 1:
            //Add multiple tasks until user types 'end'
            print("Enter tasks one by one. Type 'end' when you are done. ")
            while true {
                if let title = readLine() {
                    if title.lowercased() == "end" {
                        break
                    }
                    if !title.isEmpty {
                        let newId = todos.isEmpty ? 1 : (todos.last!.id + 1)
                        todos.append(TodoItem(id: newId, title: title, isComplete: false))
                        print("Task Added!")
                    }
                }
            }
            saveTasks()
        case 2:
            //List tasks
            for todo in todos {
                displayTask(todo)
            }
        case 3:
            // Show all tasks so the user knows which to delete
            for todo in todos {
                displayTask(todo)
            }
            print("Enter the ID of the task to delete: ")
            if let input = readLine(), let idToDelete = Int(input) {
                // Find the index of the task with given ID
                if let index = todos.firstIndex(where: { $0.id == idToDelete }) {
                    todos.remove(at: index)
                    print("Task deleted!!!")
                    saveTasks()
                } else {
                    print("Task with ID \(idToDelete) not found !")
                }
            } else {
                print("Invalid Input")
            }
        case 4:
            // Show all tasks so the user knows which to mark as complete
            for todo in todos {
                displayTask(todo)
            }
            print("Enter the ID of the task to mark it as complete")
            if let input = readLine(), let idToMark = Int(input) {
                // Find and update the task's completion date
                if let index = todos.firstIndex(where: { $0.id == idToMark }) {
                    todos[index].isComplete = true
                    print("Task marked as completed!")
                    saveTasks()
                } else {
                    print("Task with ID \(idToMark) not found !")
                }
            } else {
                print("Invalid Input")
            }
        case 5:
            // Search tasks by Title
            print("Enter search term: ")
            if let searchTerm = readLine(), !searchTerm.isEmpty {
                let results = todos.filter { $0.title.lowercased().contains(searchTerm.lowercased()) }
                if results.isEmpty {
                    print("No tasks found with '\(searchTerm)'")
                } else {
                    print("Search results: ")
                    results.forEach(displayTask)
                }
            } else {
                print("Invalid search term")
            }
        case 6:
            //Filter tasks by completion
            print("Show: 1.Completed 2.Incomplete")
            if let filterChoice = readLine(), let filter = Int(filterChoice) {
                let filteredTasks: [TodoItem]
                switch filter {
                case 1:
                    filteredTasks = todos.filter { $0.isComplete }
                    print("Completed Tasks: ")
                case 2:
                    filteredTasks = todos.filter { !$0.isComplete }
                    print("Incompleted Tasks: ")
                default:
                    filteredTasks = []
                    print("Invalid choice")
                }
                filteredTasks.forEach(displayTask)
            } else {
                print("Invalid input")
            }
        case 7:
            print("Goodbye")
            exit(0)
        default:
            print("Invaild option")
        }
    } else {
        print("Invalid input")
    }
}
