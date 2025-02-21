# Importar todas las funciones públicas
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )

foreach ($import in $Public) {
  try {
    . $import.fullname
  }
  catch {
    Write-Error -Message "Failed to import function $($import.fullname): $_"
  }
}

# Exportar las funciones públicas
Export-ModuleMember -Function $Public.Basename -Alias *