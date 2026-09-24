# DESLIGAR PC // NEON PROTOCOL

> **Style 100% refeito de `src/neon-protocol-2/`** — vanilla CSS (`--bg #020711, --panel #071426, --cyan #00eaff, --blue #168cff, --purple #874cff, --pink #ff008c`)
> Todo o frontend substituído, apenas `server/server.js` endpoints mantidos. Texto, cores e layout totalmente novos.

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

## Arquivos (Neon Protocol 2 - 100%)
```
desligar/
├── DesligarPC.ps1          # Entry point (26 linhas, dot-source src-ps/*)
├── src-ps/Theme.ps1        # Tema #020711/#00eaff (35 linhas, neon-protocol-2)
├── src-ps/UI.ps1           # UI WinForms 278 linhas (neon)
├── src-ps/Logic.ps1        # Lógica + persistência cronômetro (210 linhas)
├── index.html              # ★ Neon Protocol 2 (app 1000px, topbar, countdown-card)
├── src/input.css           # ★ style.css neon-protocol-2 (:root --bg #020711)
├── src/main.js             # ★ script.js + fetch /api/* (endpoints)
├── server/server.js        # ★★ Apenas endpoints (/shutdown, /cancel, /status)
└── package.json            # vite + express (vanilla)
```

## Criar atalho manualmente
Dentro do painel clique em **"Criar ícone na Área de Trabalho"** ou rode:
```powershell
powershell -ExecutionPolicy Bypass -File DesligarPC.ps1
# depois clique no botão dentro do app
```

O atalho criado aponta para: `powershell.exe -ExecutionPolicy Bypass -WindowStyle Normal -File "C:\...\DesligarPC.ps1"` (Neon Protocol)

## Requisitos
- Windows 10/11
- PowerShell 5.1+ (já vem no Windows)
- Sem Node, sem instalação
