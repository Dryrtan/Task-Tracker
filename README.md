# Task Tracker CLI

A command-line interface (CLI) application for managing tasks, built with Delphi Pascal. This application allows you to create, update, delete, and track the status of your tasks directly from the terminal.

## Features

- ➕ Add new tasks
- ✏️ Update existing tasks
- 🗑️ Delete tasks
- 🔄 Track task status (Todo, In Progress, Done)
- 🔍 List tasks with various filters
- 🌐 Multi-language support (English and Portuguese)
- 💾 JSON-based storage

## Installation

1. Compile the project using Delphi IDE or DCC32 compiler
2. The executable `Task_Tracker.exe` will be generated
3. The application automatically creates two files in the executable directory:
   - `tasks.json` - Stores all your tasks
   - `config.json` - Stores language preferences

## Usage

Run the application from the command line using the following syntax:

```
Task_Tracker [command] [arguments]
```

### Available Commands

#### 1. Add a New Task

Add a new task with a description.

```bash
Task_Tracker add "Your task description"
```

**Example:**
```bash
Task_Tracker add "Write project documentation"
```

**Output:**
```
Task added successfully (ID: 1)
```

---

#### 2. Update an Existing Task

Update the description of an existing task by its ID.

```bash
Task_Tracker update <id> "New description"
```

**Example:**
```bash
Task_Tracker update 1 "Update project documentation"
```

**Output:**
```
Task updated successfully
```

---

#### 3. Delete a Task

Delete a task by its ID.

```bash
Task_Tracker delete <id>
```

**Example:**
```bash
Task_Tracker delete 1
```

**Output:**
```
Task deleted successfully
```

---

#### 4. Mark Task as In Progress

Change the status of a task to "in-progress".

```bash
Task_Tracker mark-in-progress <id>
```

**Example:**
```bash
Task_Tracker mark-in-progress 1
```

**Output:**
```
Task marked as in progress
```

---

#### 5. Mark Task as Done

Change the status of a task to "done".

```bash
Task_Tracker mark-done <id>
```

**Example:**
```bash
Task_Tracker mark-done 1
```

**Output:**
```
Task marked as done
```

---

#### 6. List All Tasks

Display all tasks regardless of status.

```bash
Task_Tracker list
```

**Output:**
```
=== TASKS ===

[1] Write project documentation - Status: todo
    Created: 12/23/2025 10:30:00 AM | Updated: 12/23/2025 10:30:00 AM

[2] Fix login bug - Status: in-progress
    Created: 12/23/2025 11:00:00 AM | Updated: 12/23/2025 11:15:00 AM
```

---

#### 7. List Tasks by Status

Filter tasks by their current status.

**List pending tasks (todo):**
```bash
Task_Tracker list todo
```

**List tasks in progress:**
```bash
Task_Tracker list in-progress
```

**List completed tasks:**
```bash
Task_Tracker list done
```

---

#### 8. Change Language

Switch between English and Portuguese.

```bash
Task_Tracker lang <en|pt>
```

**Example:**
```bash
Task_Tracker lang en    # Switch to English
Task_Tracker lang pt    # Switch to Portuguese
```

**Output:**
```
Language changed to: English
```

---

#### 9. Display Help

Show all available commands and usage information.

```bash
Task_Tracker
```

or

```bash
Task_Tracker help
```

---

## Task Statuses

The application uses three task statuses:

- **todo** - Task is pending and not yet started
- **in-progress** - Task is currently being worked on
- **done** - Task is completed

## Data Storage

### tasks.json

All tasks are stored in JSON format in the `tasks.json` file located in the same directory as the executable. Example structure:

```json
[
  {
    "id": 1,
    "description": "Write project documentation",
    "status": "todo",
    "createdAt": "12/23/2025 10:30:00 AM",
    "updatedAt": "12/23/2025 10:30:00 AM"
  },
  {
    "id": 2,
    "description": "Fix login bug",
    "status": "in-progress",
    "createdAt": "12/23/2025 11:00:00 AM",
    "updatedAt": "12/23/2025 11:15:00 AM"
  }
]
```

### config.json

Language preferences are stored in `config.json`:

```json
{
  "language": "en"
}
```

## Error Handling

The application provides helpful error messages for common issues:

- **Missing description:** `Error: Description cannot be empty`
- **Invalid ID:** `Error: Invalid ID`
- **Task not found:** `Error: Task not found`
- **Missing parameters:** `Error: Missing ID and/or description`

## Examples

### Complete Workflow Example

```bash
# Add a new task
Task_Tracker add "Implement user authentication"
# Output: Task added successfully (ID: 1)

# Mark it as in progress
Task_Tracker mark-in-progress 1
# Output: Task marked as in progress

# Update the description
Task_Tracker update 1 "Implement OAuth2 authentication"
# Output: Task updated successfully

# List all in-progress tasks
Task_Tracker list in-progress

# Mark as done
Task_Tracker mark-done 1
# Output: Task marked as done

# List all completed tasks
Task_Tracker list done
```

### Quick Task Management

```bash
# Add multiple tasks
Task_Tracker add "Design database schema"
Task_Tracker add "Create API endpoints"
Task_Tracker add "Write unit tests"

# View all tasks
Task_Tracker list

# Start working on task 2
Task_Tracker mark-in-progress 2

# Complete task 1
Task_Tracker mark-done 1

# Delete task 3
Task_Tracker delete 3
```

## Project Structure

```
Task Tracker/
├── Task_Tracker.dpr          # Main program file
├── TaskTracker.Types.pas     # Task data types and JSON serialization
├── TaskTracker.Manager.pas   # Task management logic
├── TaskTracker.Language.pas  # Multi-language support
├── README.md                 # This file :)
```

## Requirements

- Windows OS
- Delphi 10.3 (for compilation)
