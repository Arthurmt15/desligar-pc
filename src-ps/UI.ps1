#Requires -Version 5.1
<#
.SYNOPSIS
    UI CYBERPUNK - construcao dos controles WinForms
.DESCRIPTION
    Cria Form, header, card de countdown, presets, inputs custom e botoes.
    Depende de Theme.ps1 (cores) ja carregado via dot-source.
    Cada secao tem comentarios de contexto para manter <300 linhas.
#>

# --- Form principal ---
# Janela fixa 460x720 centralizada, sem maximizar, icone Shield
$Form = New-Object Windows.Forms.Form
$Form.Text = "DESLIGAR PC // NEON PROTOCOL"
$Form.Size = New-Object Drawing.Size(460, 720)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = $bgMain
$Form.ForeColor = $textMain
$Form.FormBorderStyle = "FixedDialog"
$Form.MaximizeBox = $false
$Form.Font = New-Object Drawing.Font("Consolas", 9)
$Form.Icon = [Drawing.SystemIcons]::Shield

# Linhas laser topo - efeito duplo cyan + pink
$topLine = New-Object Windows.Forms.Panel
$topLine.Location = New-Object Drawing.Point(0,0)
$topLine.Size = New-Object Drawing.Size(460, 2)
$topLine.BackColor = $violet
$Form.Controls.Add($topLine)
$topLine2 = New-Object Windows.Forms.Panel
$topLine2.Location = New-Object Drawing.Point(0,2)
$topLine2.Size = New-Object Drawing.Size(460, 1)
$topLine2.BackColor = $pink
$Form.Controls.Add($topLine2)

# --- Header neon ---
$headerPanel = New-Object Windows.Forms.Panel
$headerPanel.Location = New-Object Drawing.Point(0,3)
$headerPanel.Size = New-Object Drawing.Size(460, 72)
$headerPanel.BackColor = $bgHeader
$Form.Controls.Add($headerPanel)

# linha neon fina embaixo do header
$headerLine = New-Object Windows.Forms.Panel
$headerLine.Location = New-Object Drawing.Point(0,71)
$headerLine.Size = New-Object Drawing.Size(460,1)
$headerLine.BackColor = [Drawing.Color]::FromArgb(40,240,255)
$headerPanel.Controls.Add($headerLine)

# Logo quadrado preto com borda cyan
$logoPanel = New-Object Windows.Forms.Panel
$logoPanel.Location = New-Object Drawing.Point(20, 14)
$logoPanel.Size = New-Object Drawing.Size(44, 44)
$logoPanel.BackColor = [Drawing.Color]::Black
$logoPanel.BorderStyle = "FixedSingle"
$headerPanel.Controls.Add($logoPanel)

$lblLogo = New-Object Windows.Forms.Label
$lblLogo.Text = "O" # simbolo power simplificado
$lblLogo.Font = New-Object Drawing.Font("Consolas", 16, [Drawing.FontStyle]::Bold)
$lblLogo.ForeColor = $violet
$lblLogo.Location = New-Object Drawing.Point(0,0)
$lblLogo.Size = New-Object Drawing.Size(44,44)
$lblLogo.TextAlign = "MiddleCenter"
$logoPanel.Controls.Add($lblLogo)

# Titulo e subtitulo neon
$lblTitle = New-Object Windows.Forms.Label
$lblTitle.Text = "DESLIGAR PC //"
$lblTitle.Font = New-Object Drawing.Font("Consolas", 10, [Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = [Drawing.Color]::White
$lblTitle.Location = New-Object Drawing.Point(74, 16)
$lblTitle.AutoSize = $true
$headerPanel.Controls.Add($lblTitle)

$lblSub = New-Object Windows.Forms.Label
$lblSub.Text = "NEON PROTOCOL v2.4.1  ONLINE"
$lblSub.ForeColor = $violet
$lblSub.Font = New-Object Drawing.Font("Consolas", 7, [Drawing.FontStyle]::Bold)
$lblSub.Location = New-Object Drawing.Point(74, 38)
$lblSub.AutoSize = $true
$headerPanel.Controls.Add($lblSub)

# Badge status - OCIOSO/AGENDADO (atualizado via Set-Badge)
$badge = New-Object Windows.Forms.Label
$badge.Text = " OCIOSO"
$badge.BackColor = [Drawing.Color]::Black
$badge.ForeColor = $violet
$badge.Font = New-Object Drawing.Font("Consolas", 8, [Drawing.FontStyle]::Bold)
$badge.Location = New-Object Drawing.Point(340, 22)
$badge.Size = New-Object Drawing.Size(96, 26)
$badge.TextAlign = "MiddleCenter"
$badge.BorderStyle = "FixedSingle"
$headerPanel.Controls.Add($badge)

# --- Card countdown ---
$cardTop = New-Object Windows.Forms.Panel
$cardTop.Location = New-Object Drawing.Point(16, 88)
$cardTop.Size = New-Object Drawing.Size(420, 176)
$cardTop.BackColor = $borderDim # borda externa
$Form.Controls.Add($cardTop)

$cardInner = New-Object Windows.Forms.Panel
$cardInner.Location = New-Object Drawing.Point(1,1)
$cardInner.Size = New-Object Drawing.Size(418,174)
$cardInner.BackColor = $bgCard
$cardTop.Controls.Add($cardInner)

$lblCountdownTitle = New-Object Windows.Forms.Label
$lblCountdownTitle.Text = "T-MINUS // TEMPO RESTANTE"
$lblCountdownTitle.ForeColor = $violet
$lblCountdownTitle.Font = New-Object Drawing.Font("Consolas", 7, [Drawing.FontStyle]::Bold)
$lblCountdownTitle.Location = New-Object Drawing.Point(0, 14)
$lblCountdownTitle.Size = New-Object Drawing.Size(418, 14)
$lblCountdownTitle.TextAlign = "MiddleCenter"
$cardInner.Controls.Add($lblCountdownTitle)

# Display principal HH:MM:SS
$lblCountdown = New-Object Windows.Forms.Label
$lblCountdown.Text = "00:00:00"
$lblCountdown.Font = New-Object Drawing.Font("Consolas", 36, [Drawing.FontStyle]::Bold)
$lblCountdown.ForeColor = [Drawing.Color]::White
$lblCountdown.Location = New-Object Drawing.Point(0, 34)
$lblCountdown.Size = New-Object Drawing.Size(418, 66)
$lblCountdown.TextAlign = "MiddleCenter"
$cardInner.Controls.Add($lblCountdown)

# Preview do comando shutdown
$lblCmd = New-Object Windows.Forms.Label
$lblCmd.Text = '> shutdown /s /t 0 /f  [EXEC]'
$lblCmd.Font = New-Object Drawing.Font("Consolas", 7, [Drawing.FontStyle]::Bold)
$lblCmd.ForeColor = $violet
$lblCmd.BackColor = [Drawing.Color]::Black
$lblCmd.Location = New-Object Drawing.Point(64, 108)
$lblCmd.Size = New-Object Drawing.Size(290, 18)
$lblCmd.TextAlign = "MiddleCenter"
$lblCmd.BorderStyle = "FixedSingle"
$cardInner.Controls.Add($lblCmd)

# Barra de progresso neon
$progressBg = New-Object Windows.Forms.Panel
$progressBg.Location = New-Object Drawing.Point(18, 142)
$progressBg.Size = New-Object Drawing.Size(382, 10)
$progressBg.BackColor = [Drawing.Color]::Black
$progressBg.BorderStyle = "FixedSingle"
$cardInner.Controls.Add($progressBg)

$progress = New-Object Windows.Forms.Panel
$progress.Location = New-Object Drawing.Point(0,0)
$progress.Size = New-Object Drawing.Size(0,10)
$progress.BackColor = $violet
$progressBg.Controls.Add($progress)

$lblProgressHint = New-Object Windows.Forms.Label
$lblProgressHint.Text = "PROGRESS  0%  --------------------  100% // SHUTDOWN_IMMINENT"
$lblProgressHint.ForeColor = [Drawing.Color]::FromArgb(40,100,110)
$lblProgressHint.Font = New-Object Drawing.Font("Consolas", 6)
$lblProgressHint.Location = New-Object Drawing.Point(18, 156)
$lblProgressHint.Size = New-Object Drawing.Size(382, 10)
$lblProgressHint.TextAlign = "MiddleCenter"
$cardInner.Controls.Add($lblProgressHint)

# --- Presets rapidos ---
$lblPresets = New-Object Windows.Forms.Label
$lblPresets.Text = "ATALHOS RAPIDOS  // QUICK_SELECT"
$lblPresets.Font = New-Object Drawing.Font("Consolas", 8, [Drawing.FontStyle]::Bold)
$lblPresets.ForeColor = $violet
$lblPresets.Location = New-Object Drawing.Point(20, 278)
$lblPresets.AutoSize = $true
$Form.Controls.Add($lblPresets)

$presetVals = @(15,30,60,120)
$presetTexts = @("15 MIN","30 MIN","01 HORA","02 HORAS")
$presetBorders = @($violet,$violet,$pink,$indigo)
for ($i=0; $i -lt 4; $i++) {
    $btn = New-Object Windows.Forms.Button
    $btn.Text = $presetTexts[$i]
    $btn.Tag = $presetVals[$i]
    $btn.Location = New-Object Drawing.Point((20 + $i*106), 298)
    $btn.Size = New-Object Drawing.Size(98, 36)
    $btn.FlatStyle = "Flat"
    $btn.BackColor = [Drawing.Color]::Black
    $btn.ForeColor = [Drawing.Color]::White
    $btn.Font = New-Object Drawing.Font("Consolas", 8, [Drawing.FontStyle]::Bold)
    $btn.FlatAppearance.BorderColor = $presetBorders[$i]
    $btn.FlatAppearance.BorderSize = 1
    $btn.Cursor = "Hand"
    $btn.Add_Click({
        $mins = [int]$this.Tag
        $numHours.Value = [Math]::Floor($mins/60)
        $numMins.Value = $mins % 60
        $numSecs.Value = 0
        Update-CmdPreview
    })
    $btn.Add_MouseEnter({ $this.BackColor = [Drawing.Color]::FromArgb(10,20,30) })
    $btn.Add_MouseLeave({ $this.BackColor = [Drawing.Color]::Black })
    $Form.Controls.Add($btn)
}

# --- Tempo personalizado ---
$lblCustom = New-Object Windows.Forms.Label
$lblCustom.Text = "TEMPO PERSONALIZADO  // CUSTOM_INPUT"
$lblCustom.Font = New-Object Drawing.Font("Consolas", 8, [Drawing.FontStyle]::Bold)
$lblCustom.ForeColor = $pink
$lblCustom.Location = New-Object Drawing.Point(20, 348)
$lblCustom.AutoSize = $true
$Form.Controls.Add($lblCustom)

# Helper: cria grupo Horas/Minutos/Segundos com NumericUpDown
function New-TimeGroup($x, $label, $max, $isAccent) {
    $p = New-Object Windows.Forms.Panel
    $p.Location = New-Object Drawing.Point($x, 370)
    $p.Size = New-Object Drawing.Size(130, 86)
    $p.BackColor = [Drawing.Color]::Black
    $p.BorderStyle = "FixedSingle"
    if ($isAccent) { $p.BackColor = [Drawing.Color]::FromArgb(5,10,20) } # destaque para minutos
    $lbl = New-Object Windows.Forms.Label
    $lbl.Text = $label
    $lbl.Font = New-Object Drawing.Font("Consolas", 7, [Drawing.FontStyle]::Bold)
    if ($isAccent) { $lbl.ForeColor = $violet } else { $lbl.ForeColor = $textFaint }
    $lbl.Location = New-Object Drawing.Point(0,10)
    $lbl.Size = New-Object Drawing.Size(130,14)
    $lbl.TextAlign = "MiddleCenter"
    $p.Controls.Add($lbl)
    $num = New-Object Windows.Forms.NumericUpDown
    $num.Location = New-Object Drawing.Point(26, 32)
    $num.Size = New-Object Drawing.Size(78, 30)
    $num.Font = New-Object Drawing.Font("Consolas", 15, [Drawing.FontStyle]::Bold)
    $num.BackColor = [Drawing.Color]::Black
    if ($isAccent) { $num.BackColor = [Drawing.Color]::FromArgb(5,10,20) }
    $num.ForeColor = [Drawing.Color]::White
    $num.BorderStyle = "None"
    $num.TextAlign = "Center"
    $num.Minimum = 0
    $num.Maximum = $max
    $num.Value = 0
    $p.Controls.Add($num)
    return @{ Panel=$p; Num=$num }
}

$gH = New-TimeGroup 20 "HORAS" 99 $false
$gM = New-TimeGroup 165 "MINUTOS" 59 $true
$gS = New-TimeGroup 310 "SEGUNDOS" 59 $false
$Form.Controls.Add($gH.Panel)
$Form.Controls.Add($gM.Panel)
$Form.Controls.Add($gS.Panel)
$numHours = $gH.Num
$numMins  = $gM.Num
$numSecs  = $gS.Num
$numMins.Value = 30 # preset inicial 30 min

# --- Botoes de acao ---
$btnSchedule = New-Object Windows.Forms.Button
$btnSchedule.Text = "AGENDAR DESLIGAMENTO  ▶"
$btnSchedule.Location = New-Object Drawing.Point(20, 472)
$btnSchedule.Size = New-Object Drawing.Size(420, 48)
$btnSchedule.FlatStyle = "Flat"
$btnSchedule.BackColor = $violet
$btnSchedule.ForeColor = [Drawing.Color]::Black
$btnSchedule.Font = New-Object Drawing.Font("Consolas", 10, [Drawing.FontStyle]::Bold)
$btnSchedule.FlatAppearance.BorderSize = 1
$btnSchedule.FlatAppearance.BorderColor = [Drawing.Color]::White
$btnSchedule.Cursor = "Hand"
$Form.Controls.Add($btnSchedule)

$btnCancel = New-Object Windows.Forms.Button
$btnCancel.Text = "CANCELAR"
$btnCancel.Location = New-Object Drawing.Point(20, 530)
$btnCancel.Size = New-Object Drawing.Size(204, 40)
$btnCancel.FlatStyle = "Flat"
$btnCancel.BackColor = [Drawing.Color]::Black
$btnCancel.ForeColor = $red
$btnCancel.Font = New-Object Drawing.Font("Consolas", 9, [Drawing.FontStyle]::Bold)
$btnCancel.FlatAppearance.BorderColor = $red
$btnCancel.FlatAppearance.BorderSize = 1
$btnCancel.Cursor = "Hand"
$Form.Controls.Add($btnCancel)

$btnNow = New-Object Windows.Forms.Button
$btnNow.Text = "AGORA ◆"
$btnNow.Location = New-Object Drawing.Point(236, 530)
$btnNow.Size = New-Object Drawing.Size(204, 40)
$btnNow.FlatStyle = "Flat"
$btnNow.BackColor = $amber
$btnNow.ForeColor = [Drawing.Color]::Black
$btnNow.Font = New-Object Drawing.Font("Consolas", 9, [Drawing.FontStyle]::Bold)
$btnNow.FlatAppearance.BorderSize = 0
$btnNow.Cursor = "Hand"
$Form.Controls.Add($btnNow)

# Feedback textual (sucesso/erro)
$lblFeedback = New-Object Windows.Forms.Label
$lblFeedback.Text = ""
$lblFeedback.ForeColor = $violet
$lblFeedback.Location = New-Object Drawing.Point(20, 578)
$lblFeedback.Size = New-Object Drawing.Size(420, 18)
$lblFeedback.TextAlign = "MiddleCenter"
$lblFeedback.Font = New-Object Drawing.Font("Consolas", 8, [Drawing.FontStyle]::Bold)
$Form.Controls.Add($lblFeedback)

$separator = New-Object Windows.Forms.Panel
$separator.Location = New-Object Drawing.Point(20, 604)
$separator.Size = New-Object Drawing.Size(420, 1)
$separator.BackColor = [Drawing.Color]::FromArgb(20,40,60)
$Form.Controls.Add($separator)

# Botao criar atalho na area de trabalho
$btnShortcut = New-Object Windows.Forms.Button
$btnShortcut.Text = "CRIAR ICONE  // 1-CLICK NEON_LINK"
$btnShortcut.Location = New-Object Drawing.Point(20, 618)
$btnShortcut.Size = New-Object Drawing.Size(420, 34)
$btnShortcut.FlatStyle = "Flat"
$btnShortcut.BackColor = [Drawing.Color]::White
$btnShortcut.ForeColor = [Drawing.Color]::Black
$btnShortcut.Font = New-Object Drawing.Font("Consolas", 8, [Drawing.FontStyle]::Bold)
$btnShortcut.FlatAppearance.BorderSize = 0
$btnShortcut.Cursor = "Hand"
$Form.Controls.Add($btnShortcut)
