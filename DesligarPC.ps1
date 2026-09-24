#Requires -Version 5.1
<#
.SYNOPSIS
    Desligar PC - Painel Neon Protocol (entry point)
.DESCRIPTION
    Orquestrador minimalista (<100 linhas) que importa tema, UI e logica.
    Mantido pequeno para respeitar limite de 300 linhas por arquivo.
    Toda logica pesada esta em src-ps/*.ps1, cada um <300 linhas e comentado.
.NOTES
    Uso: duplo clique em DesligarPC.bat ou atalho .lnk
    Requer: Windows PowerShell 5.1, .NET WinForms
#>

# Carrega WinForms - necessario para GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Resolve pasta do script (suporta dot-source e execucao direta)
$scriptRoot = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
if (-not $scriptRoot) { $scriptRoot = Get-Location }

# Importa tema neon (cores centralizadas)
. (Join-Path $scriptRoot "src-ps\Theme.ps1")

# Importa construcao da UI (Form, header, cards, botoes)
. (Join-Path $scriptRoot "src-ps\UI.ps1")

# Importa logica (timer, Format-Time, eventos de clique)
. (Join-Path $scriptRoot "src-ps\Logic.ps1")

# Exibe janela - blocking ate fechar
[void]$Form.ShowDialog()
