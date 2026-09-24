# NEON PROTOCOL — Design System

> Pasta unica do novo style cyberpunk do projeto. Toda cor/fonte/efeito vive aqui.

## Estrutura
```
neon-protocol/
  tokens.json        # unica fonte de verdade (cores, fontes, efeitos)
  web/
    tokens.css       # variaveis CSS :root (--neon-cyan etc)
    components.js    # styled-components (NeonCard, NeonButton, NeonBadge...)
  desktop/
    Theme.ps1        # paleta PowerShell (mesmas cores do tokens.json)
  README.md          # este guia
```

## Uso Web
```js
// App React - importa do design system
import { NeonCard, NeonButton, NeonBadge } from '../neon-protocol/web/components.js';
```
```css
/* input.css - importa tokens */
@import "../neon-protocol/web/tokens.css";
```

## Uso Desktop (WinForms)
```powershell
# DesligarPC.ps1 - importa tema centralizado
. "$PSScriptRoot/../neon-protocol/desktop/Theme.ps1"
# ou via src-ps/Theme.ps1 que re-exporta (compat)
. "$PSScriptRoot/src-ps/Theme.ps1"
```

## Cores
- Void `#02020a`, Cyan `#00F0FF`, Pink `#FF00A8`, Purple `#7000FF`
- Texto `#E2FFFD`, Mutado `#78DCF0`

## Regras
- Arquivos <300 linhas, comentados
- Nunca duplicar cor — edite `tokens.json` e sincronize `tokens.css` + `Theme.ps1`
