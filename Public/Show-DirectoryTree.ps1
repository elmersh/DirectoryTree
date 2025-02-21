function Show-DirectoryTree {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path,
      
    [Parameter()]
    [string[]]$ExcludeFolders = @("node_modules", "bin", "obj", ".git", "packages"),
      
    [Parameter()]
    [string[]]$ExcludeExtensions = @(),
      
    [Parameter()]
    [string]$OutputFile,
      
    [Parameter()]
    [switch]$ShowHidden,
      
    [Parameter()]
    [switch]$ShowFileSize,
      
    [Parameter()]
    [switch]$ShowLastModified,
      
    [Parameter()]
    [int]$MaxDepth = -1,
      
    [Parameter(DontShow)]
    [int]$CurrentDepth = 0,
      
    [Parameter(DontShow)]
    [int]$IndentLevel = 0,
      
    [Parameter(DontShow)]
    [bool]$IsLast = $false
  )

  begin {
    # Validación de ruta
    if (-not (Test-Path $Path)) {
      Write-Error "Directory '$Path' does not exist."
      return
    }

    # Función helper para formatear tamaños de archivo
    function Format-FileSize {
      param ([long]$Size)
      $sizes = 'B', 'KB', 'MB', 'GB', 'TB'
      $index = 0
      while ($Size -ge 1KB -and $index -lt ($sizes.Count - 1)) {
        $Size = $Size / 1KB
        $index++
      }
      return "{0:N2} {1}" -f $Size, $sizes[$index]
    }

    # Diccionario expandido de iconos por extensión
    $fileIcons = @{
      # Desarrollo
      ".cs"     = "📄"
      ".vb"     = "📄"
      ".java"   = "☕"
      ".py"     = "🐍"
      ".rb"     = "💎"
      ".php"    = "🐘"
      ".go"     = "🔵"
      ".rs"     = "🦀"
          
      # Web
      ".html"   = "🌐"
      ".htm"    = "🌐"
      ".css"    = "🎨"
      ".scss"   = "🎨"
      ".sass"   = "🎨"
      ".js"     = "📜"
      ".jsx"    = "📜"
      ".ts"     = "📜"
      ".tsx"    = "📜"
      ".vue"    = "🟢"
      ".svelte" = "🟠"
          
      # Datos
      ".json"   = "📋"
      ".xml"    = "📋"
      ".yaml"   = "📋"
      ".yml"    = "📋"
      ".csv"    = "📊"
      ".sql"    = "🗃️"
          
      # Documentos
      ".md"     = "📝"
      ".txt"    = "📄"
      ".doc"    = "📘"
      ".docx"   = "📘"
      ".pdf"    = "📕"
      ".xls"    = "📗"
      ".xlsx"   = "📗"
      ".ppt"    = "📙"
      ".pptx"   = "📙"
          
      # Imágenes y Media
      ".jpg"    = "🖼️"
      ".jpeg"   = "🖼️"
      ".png"    = "🖼️"
      ".gif"    = "🖼️"
      ".svg"    = "🖼️"
      ".mp3"    = "🎵"
      ".wav"    = "🎵"
      ".mp4"    = "🎥"
      ".mov"    = "🎥"
      ".avi"    = "🎥"
          
      # Archivos de proyecto y configuración
      ".sln"    = "🔨"
      ".csproj" = "🔧"
      ".vbproj" = "🔧"
      ".conf"   = "⚙️"
      ".config" = "⚙️"
      ".env"    = "🔒"
          
      # Comprimidos
      ".zip"    = "📦"
      ".rar"    = "📦"
      ".7z"     = "📦"
      ".tar"    = "📦"
      ".gz"     = "📦"
          
      # Por defecto
      "default" = "📄"
    }
  }

  process {
    # Si es el primer nivel, mostrar el nombre del directorio raíz
    if ($IndentLevel -eq 0) {
      $rootInfo = "📁 $([System.IO.Path]::GetFileName($Path))"
      if ($ShowLastModified) {
        $rootInfo += " (Modified: $((Get-Item $Path).LastWriteTime))"
      }
      Write-Output $rootInfo
          
      # Si se especificó un archivo de salida, inicializarlo
      if ($OutputFile) {
        $rootInfo | Out-File -FilePath $OutputFile
      }
    }

    # Verificar si hemos alcanzado la profundidad máxima
    if ($MaxDepth -ne -1 -and $CurrentDepth -ge $MaxDepth) {
      return
    }

    # Preparar la indentación
    $indent = "│   " * $IndentLevel

    # Obtener items del directorio con filtros
    $items = Get-ChildItem -Path $Path -Force:$ShowHidden | Where-Object { 
          ($ShowHidden -or !$_.Attributes.HasFlag([System.IO.FileAttributes]::Hidden)) -and
          ($ExcludeFolders -notcontains $_.Name) -and
          (!$_.Extension -or $ExcludeExtensions -notcontains $_.Extension)
    }

    # Procesar cada item
    for ($i = 0; $i -lt $items.Count; $i++) {
      $item = $items[$i]
      $isLastItem = ($i -eq $items.Count - 1)
      $connector = if ($isLastItem) { "└── " } else { "├── " }
          
      if ($item.PSIsContainer) {
        # Es un directorio
        $dirInfo = "$indent$connector📁 $($item.Name)"
        if ($ShowLastModified) {
          $dirInfo += " (Modified: $($item.LastWriteTime))"
        }
              
        Write-Output $dirInfo
        if ($OutputFile) {
          $dirInfo | Out-File -FilePath $OutputFile -Append
        }

        # Recursión para subdirectorios
        $newIndent = if ($isLastItem) { $IndentLevel } else { $IndentLevel + 1 }
        Show-DirectoryTree `
          -Path $item.FullName `
          -ExcludeFolders $ExcludeFolders `
          -ExcludeExtensions $ExcludeExtensions `
          -OutputFile $OutputFile `
          -ShowHidden:$ShowHidden `
          -ShowFileSize:$ShowFileSize `
          -ShowLastModified:$ShowLastModified `
          -MaxDepth $MaxDepth `
          -CurrentDepth ($CurrentDepth + 1) `
          -IndentLevel $newIndent `
          -IsLast $isLastItem
      }
      else {
        # Es un archivo
        $icon = $fileIcons[$item.Extension]
        if (-not $icon) {
          $icon = $fileIcons["default"]
        }
              
        $fileInfo = "$indent$connector$icon $($item.Name)"
              
        if ($ShowFileSize) {
          $fileInfo += " ($(Format-FileSize $item.Length))"
        }
        if ($ShowLastModified) {
          $fileInfo += " (Modified: $($item.LastWriteTime))"
        }
              
        Write-Output $fileInfo
        if ($OutputFile) {
          $fileInfo | Out-File -FilePath $OutputFile -Append
        }
      }
    }
  }
}

# Crear alias
Set-Alias -Name treew -Value Show-DirectoryTree

# Ejemplos de uso:
<#
# Uso básico
treew .

# Mostrar tamaños de archivo
treew . -ShowFileSize

# Excluir múltiples carpetas
treew . -ExcludeFolders @("node_modules", "bin", "obj", ".git")

# Excluir extensiones específicas
treew . -ExcludeExtensions @(".dll", ".exe")

# Mostrar archivos ocultos
treew . -ShowHidden

# Limitar profundidad a 2 niveles
treew . -MaxDepth 2

# Guardar salida en archivo
treew . -OutputFile "tree.txt"

# Mostrar fechas de modificación
treew . -ShowLastModified

# Combinación de parámetros
treew . -ShowFileSize -ShowLastModified -MaxDepth 3 -OutputFile "tree_detailed.txt"
#>