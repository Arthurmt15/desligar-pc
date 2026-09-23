@echo off
REM Desligar PC - Launcher otimizado (sem Node, sem npm)
REM Clique duplo para abrir o painel nativo
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0DesligarPC.ps1"
