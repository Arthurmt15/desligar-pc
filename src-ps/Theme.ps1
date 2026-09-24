#Requires -Version 5.1
<#
.SYNOPSIS
    Aurora Premium - paleta centralizada
.DESCRIPTION
    Cores do novo style Aurora (index.html + src/input.css)
    --bg #08080A, --panel #141416, --violet #7C3AED, --cyan #06B6D4, --amber #F59E0B
    Usado por UI.ps1. <300 linhas, comentado.
#>
# Fundo Aurora Premium
$bgMain    = [Drawing.Color]::FromArgb(8,8,10)       # #08080A
$bgHeader  = [Drawing.Color]::FromArgb(20,20,22)     # #141416
$bgCard    = [Drawing.Color]::FromArgb(20,20,22)
$bgCardAlt = [Drawing.Color]::FromArgb(28,28,31)     # #1C1C1F
$bgInput   = [Drawing.Color]::FromArgb(8,8,10)
$border      = [Drawing.Color]::FromArgb(124,58,237) # #7C3AED
$borderDim   = [Drawing.Color]::FromArgb(42,42,46)   # #2A2A2E
$borderLight = [Drawing.Color]::FromArgb(60,60,64)
$textMain  = [Drawing.Color]::FromArgb(250,250,250)  # #FAFAFA
$textMuted = [Drawing.Color]::FromArgb(159,159,169)  # #9F9FA9
$textFaint = [Drawing.Color]::FromArgb(113,113,122)  # #71717A
$violet      = [Drawing.Color]::FromArgb(124,58,237) # #7C3AED
$violetHover = [Drawing.Color]::FromArgb(109,40,217)
$violetDeep  = [Drawing.Color]::FromArgb(91,33,182)
$indigo      = [Drawing.Color]::FromArgb(6,182,214)  # #06B6D4
$pink        = [Drawing.Color]::FromArgb(236,72,153) # #EC4899
$pinkHover   = [Drawing.Color]::FromArgb(219,39,119)
$red       = [Drawing.Color]::FromArgb(239,68,68)   # #EF4444
$redBg     = [Drawing.Color]::FromArgb(32,16,16)
$redBorder = [Drawing.Color]::FromArgb(100,20,20)
$amber       = [Drawing.Color]::FromArgb(245,158,11)  # #F59E0B
$amberHover  = [Drawing.Color]::FromArgb(217,119,6)
$emerald     = [Drawing.Color]::FromArgb(16,185,129)
$cyanGlow    = [Drawing.Color]::FromArgb(124,58,237)
$blue        = [Drawing.Color]::FromArgb(6,182,214)
