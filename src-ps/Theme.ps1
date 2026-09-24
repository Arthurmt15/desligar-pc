#Requires -Version 5.1
<#
.SYNOPSIS
    Aurora Premium - paleta centralizada
.DESCRIPTION
    Cores do novo style Aurora (index.html + src/input.css)
    --bg #09090B, --panel #18181B, --violet #8B5CF6, --cyan #06B6D4, --amber #F59E0B, --red #EF4444
    Usado por DesligarPC.ps1 + UI.ps1. <300 linhas, comentado.
#>
# Fundo Aurora
$bgMain    = [Drawing.Color]::FromArgb(9,9,11)       # #09090B
$bgHeader  = [Drawing.Color]::FromArgb(24,24,27)     # #18181B
$bgCard    = [Drawing.Color]::FromArgb(24,24,27)     # #18181B
$bgCardAlt = [Drawing.Color]::FromArgb(39,39,42)     # #27272A
$bgInput   = [Drawing.Color]::FromArgb(9,9,11)       # #09090B
$border      = [Drawing.Color]::FromArgb(139,92,246) # #8B5CF6 violet
$borderDim   = [Drawing.Color]::FromArgb(63,63,70)   # #3F3F46
$borderLight = [Drawing.Color]::FromArgb(82,82,91)
$textMain  = [Drawing.Color]::FromArgb(250,250,250)  # #FAFAFA
$textMuted = [Drawing.Color]::FromArgb(161,161,170)  # #A1A1AA
$textFaint = [Drawing.Color]::FromArgb(113,113,122)  # #71717A
$violet      = [Drawing.Color]::FromArgb(139,92,246) # #8B5CF6
$violetHover = [Drawing.Color]::FromArgb(124,58,237)
$violetDeep  = [Drawing.Color]::FromArgb(109,40,217)
$indigo      = [Drawing.Color]::FromArgb(6,182,214)  # #06B6D4 cyan
$pink        = [Drawing.Color]::FromArgb(236,72,153) # #EC4899
$pinkHover   = [Drawing.Color]::FromArgb(219,39,119)
$red       = [Drawing.Color]::FromArgb(239,68,68)   # #EF4444
$redBg     = [Drawing.Color]::FromArgb(39,18,18)
$redBorder = [Drawing.Color]::FromArgb(127,29,29)
$amber       = [Drawing.Color]::FromArgb(245,158,11)  # #F59E0B
$amberHover  = [Drawing.Color]::FromArgb(217,119,6)
$emerald     = [Drawing.Color]::FromArgb(16,185,129)
$cyanGlow    = [Drawing.Color]::FromArgb(139,92,246)
$blue        = [Drawing.Color]::FromArgb(6,182,214)
