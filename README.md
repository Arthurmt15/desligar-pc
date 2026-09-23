# Desligar PC - Painel OTIMIZADO (Standalone)

> **Agora SEM precisar rodar `npm start` ou Node!** App nativo leve em PowerShell.

## Como usar (NOVO - Otimizado)

### Opção 1: Clique duplo (recomendado)
- **Área de Trabalho** → duplo clique em **`Desligar PC.lnk`**
- Ou na pasta → duplo clique em **`DesligarPC.bat`** ou **`DesligarPC.ps1`**

Abre instantaneamente o painel nativo (sem navegador, sem servidor, <5MB RAM).

### Opção 2: Web (antigo, ainda funciona)
```bash
npm run build
npm start
# http://localhost:3001
```

## Painel Nativo (DesligarPC.ps1)
- **Tecnologia:** PowerShell + Windows Forms (nativo do Windows, zero dependências)
- **Tamanho:** 1 arquivo (~10KB), abre em <1s
- **Otimizado:** não usa Node, Electron, navegador ou servidor

### Funcionalidades
- Atalhos: 15 min | 30 min | 1 hora | 2 horas
- Tempo personalizado: Horas (0-99) / Minutos (0-59) / Segundos (0-59)
- Countdown grande `00:00:00` + barra de progresso
- **Agendar** → `shutdown /s /t X /f`
- **Cancelar** → `shutdown /a`
- **Desligar agora** → `shutdown /s /t 0 /f`
- **Criar ícone na Área de Trabalho** → botão dentro do app

## Arquivos
```
desligar/
├── DesligarPC.ps1          # ★ APP PRINCIPAL - standalone otimizado
├── DesligarPC.bat          # Launcher (duplo clique)
├── iniciar-desligar.bat    # Atalho compatível
├── dist/                   # Build web (opcional)
├── server/server.js        # Backend web (legado, não precisa mais)
├── src/ + index.html       # Frontend web (legado)
└── package.json
```

## Criar atalho manualmente
Dentro do painel clique em **"Criar ícone na Área de Trabalho"** ou rode:
```powershell
powershell -ExecutionPolicy Bypass -File DesligarPC.ps1
# depois clique no botão dentro do app
```

O atalho criado aponta para: `powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\...\DesligarPC.ps1"`

## Requisitos
- Windows 10/11
- PowerShell 5.1+ (já vem no Windows)
- Sem Node, sem instalação
