# DESLIGAR PC // NEON PROTOCOL v2.4.1

> **Design System centralizado em `neon-protocol/`** — style cyberpunk com `styled-components` + WinForms neon.
> App nativo PowerShell + web Vite/Tailwind, ambos consomem `neon-protocol/tokens.json`.

## Style Central
- `neon-protocol/tokens.json` — única fonte de verdade (cores `#02020a/#00F0FF/#FF00A8`)
- `neon-protocol/web/tokens.css` + `components.js` — styled-components web
- `neon-protocol/desktop/Theme.ps1` — paleta WinForms (re-exportado por `src-ps/Theme.ps1`)
- Veja `neon-protocol/README.md` para guia completo.

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
├── DesligarPC.ps1          # ★ Entry point (26 linhas, dot-source src-ps/*)
├── src-ps/Theme.ps1        # Proxy -> neon-protocol/desktop/Theme.ps1
├── src-ps/UI.ps1           # UI WinForms neon (290 linhas)
├── src-ps/Logic.ps1        # Lógica + Format-Time fix
├── neon-protocol/          # ★ DESIGN SYSTEM centralizado
│   ├── tokens.json         # cores/fontes
│   ├── web/tokens.css + components.js
│   └── desktop/Theme.ps1
├── DesligarPC.bat          # Launcher NEON PROTOCOL
├── src/ + index.html       # Frontend web neon (var --neon-*)
├── src/styled/neon.js      # Proxy -> neon-protocol/web/components.js
├── server/server.js        # Backend Express com logs neon
└── package.json            # styled-components + react
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
