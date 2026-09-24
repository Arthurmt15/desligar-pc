#Requires -Version 5.1
<#
.SYNOPSIS
    Tema NEON CYBERPUNK - paleta de cores centralizada
.DESCRIPTION
    Define todas as cores usadas no painel WinForms.
    Mantido separado para facilitar troca de tema sem tocar na UI/logica.
    Limite: <300 linhas, bem comentado.
.NOTES
    Cores em ARGB: [Drawing.Color]::FromArgb(R,G,B)
#>

# Fundo principal - void escuro cyberpunk
$bgMain    = [Drawing.Color]::FromArgb(2,2,10)      # #02020a - fundo da janela
$bgHeader  = [Drawing.Color]::FromArgb(5,7,18)      # #050712 - header translucido
$bgCard    = [Drawing.Color]::FromArgb(6,8,20)      # #060814 - cards
$bgCardAlt = [Drawing.Color]::FromArgb(8,10,28)     # #080A1C - card interno
$bgInput   = [Drawing.Color]::FromArgb(0,0,0)       # inputs pretos neon

# Bordas neon
$border      = [Drawing.Color]::FromArgb(0,240,255) # cyan principal
$borderDim   = [Drawing.Color]::FromArgb(30,60,80)  # borda dim para card externo
$borderLight = [Drawing.Color]::FromArgb(0,200,220)

# Texto
$textMain  = [Drawing.Color]::FromArgb(226,255,253) # branco neon
$textMuted = [Drawing.Color]::FromArgb(120,220,240) # cyan muted
$textFaint = [Drawing.Color]::FromArgb(80,100,120)  # labels secundarias

# Acentos primarios - cyberpunk
$violet      = [Drawing.Color]::FromArgb(0,240,255) # cyan (substitui violet antigo)
$violetHover = [Drawing.Color]::FromArgb(0,210,235) # hover cyan
$violetDeep  = [Drawing.Color]::FromArgb(0,170,200)
$indigo      = [Drawing.Color]::FromArgb(112,0,255) # roxo neon
$pink        = [Drawing.Color]::FromArgb(255,0,168) # pink neon - contraste
$pinkHover   = [Drawing.Color]::FromArgb(230,0,150)

# Estados
$red       = [Drawing.Color]::FromArgb(255,0,64)   # erro / cancelar - neon red
$redBg     = [Drawing.Color]::FromArgb(20,0,10)    # fundo botao cancelar
$redBorder = [Drawing.Color]::FromArgb(80,0,30)
$amber       = [Drawing.Color]::FromArgb(255,208,0)  # acao imediata - cyber yellow
$amberHover  = [Drawing.Color]::FromArgb(255,225,40)
$emerald     = [Drawing.Color]::FromArgb(0,240,255)  # sucesso = cyan
$cyanGlow    = [Drawing.Color]::FromArgb(0,240,255)
