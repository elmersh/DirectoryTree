@{
  RootModule        = 'DirectoryTree.psm1'
  ModuleVersion     = '1.0.2'
  GUID              = '79822dfd-1e7e-4f92-9b9b-bb557a726b3b'
  Author            = 'Elmer S.'
  Description       = 'A directory tree viewer with icons and formatting options'
  PowerShellVersion = '5.1'
  FunctionsToExport = @('Show-DirectoryTree')
  CmdletsToExport   = @()
  VariablesToExport = '*'
  AliasesToExport   = @('treew')

  PrivateData       = @{
    PSData = @{
      Tags       = @('FileSystem', 'Utility', 'Tree', 'Directory')
      ProjectUri = 'https://github.com/elmersh/DirectoryTree'
      LicenseUri = 'https://github.com/elmersh/DirectoryTree/blob/main/LICENSE'
    }
  }
}