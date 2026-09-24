@echo off
REM Desligar PC - Launcher OTIMIZADO (standalone, sem Node/npm)
REM Agora abre o painel nativo em PowerShell - leve e instantaneo
powershell -ExecutionPolicy Bypass -WindowStyle Normal -File "%~dp0DesligarPC.ps1"
