#Requires -Version 5.1
<#
.SYNOPSIS
    Proxy NEON PROTOCOL - re-exporta tema centralizado
.DESCRIPTION
    Fonte unica: neon-protocol/desktop/Theme.ps1
    Mantido para compatibilidade (DesligarPC.ps1 faz dot-source aqui)
    Edite neon-protocol/desktop/Theme.ps1, nao este arquivo.
#>
# Importa tema centralizado (unica fonte de verdade)
$central = Join-Path (Split-Path $PSScriptRoot -Parent) "neon-protocol\desktop\Theme.ps1"
if (Test-Path $central) { . $central } else { Write-Warning "NEON PROTOCOL Theme.ps1 nao encontrado em $central" }
