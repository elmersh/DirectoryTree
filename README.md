# DirectoryTree

A PowerShell module for displaying directory trees with icons and formatting options.

## Installation

```powershell
Install-Module -Name DirectoryTree
```

## Usage

```powershell
# Basic usage
Show-DirectoryTree .
# or use the alias
treew .

# Show file sizes
Show-DirectoryTree . -ShowFileSize

# Show last modified dates
Show-DirectoryTree . -ShowLastModified

# Exclude specific folders
Show-DirectoryTree . -ExcludeFolders @("node_modules", "bin")

# Save to file
Show-DirectoryTree . -OutputFile "tree.txt"
```

## Parameters

- `-Path`: Directory path to start from
- `-ExcludeFolders`: Folders to exclude
- `-ExcludeExtensions`: File extensions to exclude
- `-ShowHidden`: Show hidden files and folders
- `-ShowFileSize`: Display file sizes
- `-ShowLastModified`: Show last modified dates
- `-MaxDepth`: Maximum depth to traverse
- `-OutputFile`: Save output to file

## License

MIT (or tu licencia preferida)
