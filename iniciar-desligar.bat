@echo off
REM Atalho Desligar PC - inicia servidor e abre painel
cd /d "c:\Users\Martiniano\Documents\desligar-pc"
echo Iniciando painel Desligar PC...
start "" http://localhost:3001
node server/server.js
pause

