#Requires -Version 5.1
<#
.SYNOPSIS
    Tema Neon Protocol v2 Style - src/neon_protocol_v2_style
.DESCRIPTION
    --bg-dark #070a12, --panel-bg #0d1321, --cyan #00f3ff, --magenta #ff0055, --yellow #ffbe00, --green #00ff66
    Usado por UI.ps1. <300 linhas.
#>
$bgMain    = [Drawing.Color]::FromArgb(7,10,18)      # #070a12
$bgHeader  = [Drawing.Color]::FromArgb(13,19,33)     # #0d1321
$bgCard    = [Drawing.Color]::FromArgb(13,19,33)
$bgCardAlt = [Drawing.Color]::FromArgb(5,8,15)       # #05080f
$bgInput   = [Drawing.Color]::FromArgb(0,0,0)        # #000 (transparent)
$border      = [Drawing.Color]::FromArgb(0,243,255)  # #00f3ff
$borderDim   = [Drawing.Color]::FromArgb(90,115,142) # #5a738e
$borderLight = [Drawing.Color]::FromArgb(0,243,255)
$textMain  = [Drawing.Color]::FromArgb(226,241,175)  # #e2f1af
$textMuted = [Drawing.Color]::FromArgb(90,115,142)   # #5a738e
$textFaint = [Drawing.Color]::FromArgb(90,115,142)
$violet      = [Drawing.Color]::FromArgb(0,243,255)  # #00f3ff (cyan-neon)
$violetHover = [Drawing.Color]::FromArgb(51,245,255)
$violetDeep  = [Drawing.Color]::FromArgb(0,210,220)
$indigo      = [Drawing.Color]::FromArgb(0,243,255)
$pink        = [Drawing.Color]::FromArgb(255,0,85)   # #ff0055 magenta
$pinkHover   = [Drawing.Color]::FromArgb(230,0,77)
$red       = [Drawing.Color]::FromArgb(255,0,85)
$redBg     = [Drawing.Color]::FromArgb(40,0,20)
$redBorder = [Drawing.Color]::FromArgb(255,0,85)
$amber       = [Drawing.Color]::FromArgb(255,190,0)  # #ffbe00 yellow
$amberHover  = [Drawing.Color]::FromArgb(255,210,40)
$emerald     = [Drawing.Color]::FromArgb(0,255,102)  # #00ff66
$cyanGlow    = [Drawing.Color]::FromArgb(0,243,255)
$blue        = [Drawing.Color]::FromArgb(0,243,255)
