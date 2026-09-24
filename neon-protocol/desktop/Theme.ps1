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

# Fundo - neon-protocol-2 (#020711, #071426)
$bgMain    = [Drawing.Color]::FromArgb(2,7,17)      # #020711
$bgHeader  = [Drawing.Color]::FromArgb(7,20,38)     # #071426
$bgCard    = [Drawing.Color]::FromArgb(7,20,38)     # #071426
$bgCardAlt = [Drawing.Color]::FromArgb(6,19,38)     # #061326
$bgInput   = [Drawing.Color]::FromArgb(11,27,52)    # #0b1b34

# Bordas neon 2
$border      = [Drawing.Color]::FromArgb(0,234,255) # #00eaff cyan
$borderDim   = [Drawing.Color]::FromArgb(0,140,255) # #008cff blue
$borderLight = [Drawing.Color]::FromArgb(22,140,255)

# Texto
$textMain  = [Drawing.Color]::FromArgb(245,248,255) # #f5f8ff
$textMuted = [Drawing.Color]::FromArgb(114,168,221) # #72a8dd
$textFaint = [Drawing.Color]::FromArgb(90,130,170)

# Acentos - neon-protocol-2
$violet      = [Drawing.Color]::FromArgb(0,234,255) # #00eaff
$violetHover = [Drawing.Color]::FromArgb(0,210,240)
$violetDeep  = [Drawing.Color]::FromArgb(0,180,210)
$indigo      = [Drawing.Color]::FromArgb(135,76,255) # #874cff purple
$pink        = [Drawing.Color]::FromArgb(255,0,140) # #ff008c
$pinkHover   = [Drawing.Color]::FromArgb(230,0,120)

# Estados
$red       = [Drawing.Color]::FromArgb(255,0,106)  # #ff006a
$redBg     = [Drawing.Color]::FromArgb(50,0,25)
$redBorder = [Drawing.Color]::FromArgb(255,0,106)
$amber       = [Drawing.Color]::FromArgb(255,217,0)  # #ffd900
$amberHover  = [Drawing.Color]::FromArgb(255,230,40)
$emerald     = [Drawing.Color]::FromArgb(0,234,255)
$cyanGlow    = [Drawing.Color]::FromArgb(0,234,255)
$blue        = [Drawing.Color]::FromArgb(22,140,255) # #168cff
