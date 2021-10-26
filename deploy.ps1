$ModuleName = "RallyQuickTools"
((Get-content -path ".\$($ModuleName).psd1") -replace '9.9.9','<ModuleVersion>') | Set-Content -path ".\$($ModuleName).psd1"