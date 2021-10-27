Set-StrictMode -Version Latest
$functions  = @( Get-ChildItem -Recurse -Filter "*.ps1" -Path "Functions/" )

@($functions) | ForEach-Object {
    Try {
        Write-Verbose "Importing $($import.FullName)"
        . $_.FullName
    } Catch {
        Write-Error -Message "Failed to import function $($_.FullName): $_"
    }
}

foreach ($file in $functions) {
    Export-ModuleMember -Function $file.BaseName
}