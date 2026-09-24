#Requires -Version 5.1
<#
.SYNOPSIS
    Lumen Premium - paleta
.DESCRIPTION
    Cores do novo style Lumen (index.html + src/input.css)
    --bg #0A0A0B, --panel #141416, --violet #7C3AED, --cyan #06B6D4
    Usado por UI.ps1. <300 linhas.
#>
$bgMain    = [Drawing.Color]::FromArgb(10,10,11)     # #0A0A0B
$bgHeader  = [Drawing.Color]::FromArgb(20,20,22)     # #141416
$bgCard    = [Drawing.Color]::FromArgb(20,20,22)
$bgCardAlt = [Drawing.Color]::FromArgb(28,28,31)     # #1C1C1F
$bgInput   = [Drawing.Color]::FromArgb(10,10,11)
$border      = [Drawing.Color]::FromArgb(124,58,237) # #7C3AED
$borderDim   = [Drawing.Color]::FromArgb(42,42,46)   # #2A2A2E
$borderLight = [Drawing.Color]::FromArgb(60,60,64)
$textMain  = [Drawing.Color]::FromArgb(250,250,250)
$textMuted = [Drawing.Color]::FromArgb(159,159,169)
$textFaint = [Drawing.Color]::FromArgb(113,113,122)
$violet      = [Drawing.Color]::FromArgb(124,58,237)
$violetHover = [Drawing.Color]::FromArgb(109,40,217)
$violetDeep  = [Drawing.Color]::FromArgb(91,33,182)
$indigo      = [Drawing.Color]::FromArgb(6,182,214)
$pink        = [Drawing.Color]::FromArgb(236,72,153)
$pinkHover   = [Drawing.Color]::FromArgb(219,39,119)
$red       = [Drawing.Color]::FromArgb(239,68,68)
$redBg     = [Drawing.Color]::FromArgb(32,16,16)
$redBorder = [Drawing.Color]::FromArgb(100,20,20)
$amber       = [Drawing.Color]::FromArgb(245,158,11)
$amberHover  = [Drawing.Color]::FromArgb(217,119,6)
$emerald     = [Drawing.Color]::FromArgb(16,185,129)
$cyanGlow    = [Drawing.Color]::FromArgb(124,58,237)
$blue        = [Drawing.Color]::FromArgb(6,182,214)
