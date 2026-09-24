#Requires -Version 5.1
<#
.SYNOPSIS
    Tema Neon Protocol 2 - paleta do src/neon-protocol-2/style.css
.DESCRIPTION
    --bg #020711, --panel #071426, --cyan #00eaff, --blue #168cff, --purple #874cff, --pink #ff008c
    Usado por UI.ps1. <300 linhas, comentado.
#>
$bgMain    = [Drawing.Color]::FromArgb(2,7,17)      # #020711
$bgHeader  = [Drawing.Color]::FromArgb(7,20,38)     # #071426
$bgCard    = [Drawing.Color]::FromArgb(7,20,38)
$bgCardAlt = [Drawing.Color]::FromArgb(6,19,38)     # #061326
$bgInput   = [Drawing.Color]::FromArgb(11,27,52)    # #0b1b34
$border      = [Drawing.Color]::FromArgb(0,234,255) # #00eaff
$borderDim   = [Drawing.Color]::FromArgb(0,140,255) # #008cff
$borderLight = [Drawing.Color]::FromArgb(22,140,255)
$textMain  = [Drawing.Color]::FromArgb(245,248,255) # #f5f8ff
$textMuted = [Drawing.Color]::FromArgb(114,168,221) # #72a8dd
$textFaint = [Drawing.Color]::FromArgb(90,130,170)
$violet      = [Drawing.Color]::FromArgb(0,234,255) # #00eaff
$violetHover = [Drawing.Color]::FromArgb(0,210,240)
$violetDeep  = [Drawing.Color]::FromArgb(0,180,210)
$indigo      = [Drawing.Color]::FromArgb(135,76,255) # #874cff
$pink        = [Drawing.Color]::FromArgb(255,0,140) # #ff008c
$pinkHover   = [Drawing.Color]::FromArgb(230,0,120)
$red       = [Drawing.Color]::FromArgb(255,0,106)  # #ff006a
$redBg     = [Drawing.Color]::FromArgb(50,0,25)
$redBorder = [Drawing.Color]::FromArgb(255,0,106)
$amber       = [Drawing.Color]::FromArgb(255,217,0)
$amberHover  = [Drawing.Color]::FromArgb(255,230,40)
$emerald     = [Drawing.Color]::FromArgb(0,234,255)
$cyanGlow    = [Drawing.Color]::FromArgb(0,234,255)
$blue        = [Drawing.Color]::FromArgb(22,140,255)
