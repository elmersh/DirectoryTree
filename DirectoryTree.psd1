@{
  RootModule        = 'DirectoryTree.psm1'
  ModuleVersion     = '1.0.0'
  GUID              = '12345678-1234-1234-1234-123456789012' # Genera un nuevo GUID
  Author            = 'Elmer S.'
  Description       = 'A directory tree viewer with icons and formatting options'
  PowerShellVersion = '5.1'
  FunctionsToExport = @('Show-DirectoryTree')
  CmdletsToExport   = @()
  VariablesToExport = '*'
  AliasesToExport   = @('treew')
  Tags              = @('FileSystem', 'Utility', 'Tree', 'Directory')
  ProjectUri        = 'https://github.com/elmersh/DirectoryTree'
  LicenseUri        = 'https://github.com/elmersh/DirectoryTree/blob/main/LICENSE'
}