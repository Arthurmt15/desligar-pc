#Requires -Version 5.1
# UI Neon Protocol v2 Style - WinForms gira Theme.ps1 (neon_protocol_v2_style)
# Container 480px, Orbitron/Rajdhani, --bg-dark #070a12 --cyan #00f3ff --magenta #ff0055

$Form = New-Object Windows.Forms.Form
$Form.Text = "DESLIGAR PC // NEON PROTOCOL v2.0"
$Form.Size = New-Object Drawing.Size(520, 860)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = $bgMain
$Form.ForeColor = $textMain
$Form.FormBorderStyle = "FixedDialog"
$Form.MaximizeBox = $false
$Form.Font = New-Object Drawing.Font("Consolas", 9)

# Scanline overlay simulado (barra fina topo)
$topGlow = New-Object Windows.Forms.Panel
$topGlow.Location = New-Object Drawing.Point(20, 20)
$topGlow.Size = New-Object Drawing.Size(480, 2)
$topGlow.BackColor = $border
$Form.Controls.Add($topGlow)

# Container principal 480px
$container = New-Object Windows.Forms.Panel
$container.Location = New-Object Drawing.Point(20, 22)
$container.Size = New-Object Drawing.Size(480, 780)
$container.BackColor = $bgHeader
$container.BorderStyle = "FixedSingle"
$Form.Controls.Add($container)

# Header
$headerPanel = New-Object Windows.Forms.Panel
$headerPanel.Location = New-Object Drawing.Point(0, 0)
$headerPanel.Size = New-Object Drawing.Size(480, 70)
$headerPanel.BackColor = [Drawing.Color]::FromArgb(13,19,33)
$container.Controls.Add($headerPanel)

$iconBadge = New-Object Windows.Forms.Panel
$iconBadge.Location = New-Object Drawing.Point(16, 14)
$iconBadge.Size = New-Object Drawing.Size(42, 42)
$iconBadge.BackColor = [Drawing.Color]::FromArgb(0,243,255)
$iconBadge.BackColor = [Drawing.Color]::FromArgb(20,40,50)
$iconBadge.BorderStyle = "FixedSingle"
$headerPanel.Controls.Add($iconBadge)
$lblIcon = New-Object Windows.Forms.Label
$lblIcon.Text = "⏻"
$lblIcon.Font = New-Object Drawing.Font("Consolas", 16, [Drawing.FontStyle]::Bold)
$lblIcon.ForeColor = $border
$lblIcon.Location = New-Object Drawing.Point(0,0)
$lblIcon.Size = New-Object Drawing.Size(42,42)
$lblIcon.TextAlign = "MiddleCenter"
$iconBadge.Controls.Add($lblIcon)

$lblTitle = New-Object Windows.Forms.Label
$lblTitle.Text = "DESLIGAR PC"
$lblTitle.Font = New-Object Drawing.Font("Consolas", 10, [Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = [Drawing.Color]::White
$lblTitle.Location = New-Object Drawing.Point(70, 14)
$lblTitle.AutoSize = $true
$headerPanel.Controls.Add($lblTitle)
$lblSub = New-Object Windows.Forms.Label
$lblSub.Text = "NEON PROTOCOL v2.0"
$lblSub.Font = New-Object Drawing.Font("Consolas", 7, [Drawing.FontStyle]::Bold)
$lblSub.ForeColor = $border
$lblSub.Location = New-Object Drawing.Point(70, 36)
$lblSub.AutoSize = $true
$headerPanel.Controls.Add($lblSub)

$badge = New-Object Windows.Forms.Label
$badge.Text = " OCIOSO"
$badge.BackColor = [Drawing.Color]::FromArgb(255,255,255,12)
$badge.ForeColor = $textMuted
$badge.Font = New-Object Drawing.Font("Consolas", 7, [Drawing.FontStyle]::Bold)
$badge.Location = New-Object Drawing.Point(360, 20)
$badge.Size = New-Object Drawing.Size(100, 24)
$badge.TextAlign = "MiddleCenter"
$badge.BorderStyle = "FixedSingle"
$headerPanel.Controls.Add($badge)
# Alias para novo style statusPill
$statusPill = $badge
$statusText = $badge

# Header bottom border
$headerLine = New-Object Windows.Forms.Panel
$headerLine.Location = New-Object Drawing.Point(0, 69)
$headerLine.Size = New-Object Drawing.Size(480, 1)
$headerLine.BackColor = [Drawing.Color]::FromArgb(30,60,80)
$container.Controls.Add($headerLine)

# Timer display box 440x150
$timerBox = New-Object Windows.Forms.Panel
$timerBox.Location = New-Object Drawing.Point(20, 84)
$timerBox.Size = New-Object Drawing.Size(440, 160)
$timerBox.BackColor = [Drawing.Color]::FromArgb(5,8,15)
$timerBox.BorderStyle = "FixedSingle"
$container.Controls.Add($timerBox)

$displayLabel = New-Object Windows.Forms.Label
$displayLabel.Text = "T-MINUS // TEMPO RESTANTE"
$displayLabel.ForeColor = $textMuted
$displayLabel.Font = New-Object Drawing.Font("Consolas", 7, [Drawing.FontStyle]::Bold)
$displayLabel.Location = New-Object Drawing.Point(0, 14)
$displayLabel.Size = New-Object Drawing.Size(440, 14)
$displayLabel.TextAlign = "MiddleCenter"
$timerBox.Controls.Add($displayLabel)

$lblCountdown = New-Object Windows.Forms.Label
$lblCountdown.Text = "00:00:00"
$lblCountdown.Font = New-Object Drawing.Font("Consolas", 30, [Drawing.FontStyle]::Bold)
$lblCountdown.ForeColor = [Drawing.Color]::White
$lblCountdown.Location = New-Object Drawing.Point(0, 36)
$lblCountdown.Size = New-Object Drawing.Size(440, 50)
$lblCountdown.TextAlign = "MiddleCenter"
$timerBox.Controls.Add($lblCountdown)
# Alias timerDisplay/cmdPreview para compatibilidade novo style
$timerDisplay = $lblCountdown

$lblCmd = New-Object Windows.Forms.Label
$lblCmd.Text = "shutdown /s /t 0 /f"
$lblCmd.Font = New-Object Drawing.Font("Consolas", 7, [Drawing.FontStyle]::Bold)
$lblCmd.ForeColor = $border
$lblCmd.BackColor = [Drawing.Color]::FromArgb(0,0,0,120)
$lblCmd.Location = New-Object Drawing.Point(70, 94)
$lblCmd.Size = New-Object Drawing.Size(300, 18)
$lblCmd.TextAlign = "MiddleCenter"
$lblCmd.BorderStyle = "FixedSingle"
$timerBox.Controls.Add($lblCmd)
$cmdPreview = $lblCmd

$progressBg = New-Object Windows.Forms.Panel
$progressBg.Location = New-Object Drawing.Point(20, 130)
$progressBg.Size = New-Object Drawing.Size(400, 6)
$progressBg.BackColor = [Drawing.Color]::FromArgb(40,40,50)
$timerBox.Controls.Add($progressBg)
$progress = New-Object Windows.Forms.Panel
$progress.Location = New-Object Drawing.Point(0,0)
$progress.Size = New-Object Drawing.Size(0,6)
$progress.BackColor = $border
$progressBg.Controls.Add($progress)
$progressBar = $progress

# Section Atalhos Rapidos
$lblPresets = New-Object Windows.Forms.Label
$lblPresets.Text = " ATALHOS RÁPIDOS"
$lblPresets.Font = New-Object Drawing.Font("Consolas", 8, [Drawing.FontStyle]::Bold)
$lblPresets.ForeColor = $border
$lblPresets.Location = New-Object Drawing.Point(20, 260)
$lblPresets.Size = New-Object Drawing.Size(440, 14)
$container.Controls.Add($lblPresets)

$presetVals = @(15,30,60,120)
$presetTexts = @("15 MIN","30 MIN","01 HORA","02 HORAS")
for ($i=0; $i -lt 4; $i++) {
    $btn = New-Object Windows.Forms.Button
    $btn.Text = $presetTexts[$i]
    $btn.Tag = $presetVals[$i]
    $btn.Location = New-Object Drawing.Point((20 + $i*110), 280)
    $btn.Size = New-Object Drawing.Size(102, 38)
    $btn.FlatStyle = "Flat"
    $btn.BackColor = [Drawing.Color]::FromArgb(30,30,35)
    $btn.ForeColor = [Drawing.Color]::WhiteSmoke
    $btn.Font = New-Object Drawing.Font("Consolas", 8, [Drawing.FontStyle]::Bold)
    $btn.FlatAppearance.BorderColor = [Drawing.Color]::FromArgb(60,60,65)
    $btn.FlatAppearance.BorderSize = 1
    $btn.Cursor = "Hand"
    $btn.Add_Click({
        $mins = [int]$this.Tag
        $numHours.Value = [Math]::Floor($mins/60)
        $numMins.Value = $mins % 60
        $numSecs.Value = 0
        Update-CmdPreview
    })
    $btn.Add_MouseEnter({ $this.BackColor = [Drawing.Color]::FromArgb(0,40,50); $this.FlatAppearance.BorderColor = $border })
    $btn.Add_MouseLeave({ $this.BackColor = [Drawing.Color]::FromArgb(30,30,35); $this.FlatAppearance.BorderColor = [Drawing.Color]::FromArgb(60,60,65) })
    $container.Controls.Add($btn)
}

# Tempo Personalizado
$lblCustom = New-Object Windows.Forms.Label
$lblCustom.Text = " TEMPO PERSONALIZADO"
$lblCustom.Font = New-Object Drawing.Font("Consolas", 8, [Drawing.FontStyle]::Bold)
$lblCustom.ForeColor = $border
$lblCustom.Location = New-Object Drawing.Point(20, 334)
$lblCustom.Size = New-Object Drawing.Size(440, 14)
$container.Controls.Add($lblCustom)

function New-TimeGroup($x, $label, $max) {
    $p = New-Object Windows.Forms.Panel
    $p.Location = New-Object Drawing.Point($x, 354)
    $p.Size = New-Object Drawing.Size(138, 90)
    $p.BackColor = [Drawing.Color]::FromArgb(0,0,0,80)
    $p.BorderStyle = "FixedSingle"
    $lbl = New-Object Windows.Forms.Label
    $lbl.Text = $label
    $lbl.Font = New-Object Drawing.Font("Consolas", 7, [Drawing.FontStyle]::Bold)
    $lbl.ForeColor = $textMuted
    $lbl.Location = New-Object Drawing.Point(0,10)
    $lbl.Size = New-Object Drawing.Size(138,14)
    $lbl.TextAlign = "MiddleCenter"
    $p.Controls.Add($lbl)
    $num = New-Object Windows.Forms.NumericUpDown
    $num.Location = New-Object Drawing.Point(30, 34)
    $num.Size = New-Object Drawing.Size(78, 30)
    $num.Font = New-Object Drawing.Font("Consolas", 14, [Drawing.FontStyle]::Bold)
    $num.BackColor = [Drawing.Color]::Black
    $num.ForeColor = [Drawing.Color]::White
    $num.BorderStyle = "None"
    $num.TextAlign = "Center"
    $num.Minimum = 0
    $num.Maximum = $max
    $num.Value = 0
    $p.Controls.Add($num)
    # spin buttons overlay (usados pelo Logic via ValueChanged, mas adicionamos click areas)
    return @{ Panel=$p; Num=$num }
}
$gH = New-TimeGroup 20 "HORAS" 24
$gM = New-TimeGroup 171 "MINUTOS" 59
$gS = New-TimeGroup 322 "SEGUNDOS" 59
$container.Controls.Add($gH.Panel)
$container.Controls.Add($gM.Panel)
$container.Controls.Add($gS.Panel)
$numHours = $gH.Num
$numMins  = $gM.Num
$numSecs  = $gS.Num
$numMins.Value = 30

# Botoes acao
$btnSchedule = New-Object Windows.Forms.Button
$btnSchedule.Text = " AGENDAR DESLIGAMENTO"
$btnSchedule.Location = New-Object Drawing.Point(20, 466)
$btnSchedule.Size = New-Object Drawing.Size(440, 50)
$btnSchedule.FlatStyle = "Flat"
$btnSchedule.BackColor = $border
$btnSchedule.ForeColor = $bgMain
$btnSchedule.Font = New-Object Drawing.Font("Consolas", 10, [Drawing.FontStyle]::Bold)
$btnSchedule.FlatAppearance.BorderSize = 0
$btnSchedule.Cursor = "Hand"
$container.Controls.Add($btnSchedule)

$btnCancel = New-Object Windows.Forms.Button
$btnCancel.Text = "CANCELAR"
$btnCancel.Location = New-Object Drawing.Point(20, 528)
$btnCancel.Size = New-Object Drawing.Size(212, 44)
$btnCancel.FlatStyle = "Flat"
$btnCancel.BackColor = [Drawing.Color]::FromArgb(40,10,20)
$btnCancel.ForeColor = $pink
$btnCancel.Font = New-Object Drawing.Font("Consolas", 9, [Drawing.FontStyle]::Bold)
$btnCancel.FlatAppearance.BorderColor = $pink
$btnCancel.FlatAppearance.BorderSize = 1
$btnCancel.Cursor = "Hand"
$container.Controls.Add($btnCancel)

$btnNow = New-Object Windows.Forms.Button
$btnNow.Text = "AGORA"
$btnNow.Location = New-Object Drawing.Point(248, 528)
$btnNow.Size = New-Object Drawing.Size(212, 44)
$btnNow.FlatStyle = "Flat"
$btnNow.BackColor = [Drawing.Color]::FromArgb(40,35,0)
$btnNow.ForeColor = $amber
$btnNow.Font = New-Object Drawing.Font("Consolas", 9, [Drawing.FontStyle]::Bold)
$btnNow.FlatAppearance.BorderColor = $amber
$btnNow.FlatAppearance.BorderSize = 1
$btnNow.Cursor = "Hand"
$container.Controls.Add($btnNow)

$lblFeedback = New-Object Windows.Forms.Label
$lblFeedback.Text = ""
$lblFeedback.ForeColor = $border
$lblFeedback.Location = New-Object Drawing.Point(20, 582)
$lblFeedback.Size = New-Object Drawing.Size(440, 18)
$lblFeedback.TextAlign = "MiddleCenter"
$lblFeedback.Font = New-Object Drawing.Font("Consolas", 8, [Drawing.FontStyle]::Bold)
$container.Controls.Add($lblFeedback)

$separator = New-Object Windows.Forms.Panel
$separator.Location = New-Object Drawing.Point(20, 606)
$separator.Size = New-Object Drawing.Size(440, 1)
$separator.BackColor = [Drawing.Color]::FromArgb(30,50,70)
$container.Controls.Add($separator)

$btnShortcut = New-Object Windows.Forms.Button
$btnShortcut.Text = "CRIAR ÍCONE // 1-CLICK NEON_LINK"
$btnShortcut.Location = New-Object Drawing.Point(20, 620)
$btnShortcut.Size = New-Object Drawing.Size(440, 36)
$btnShortcut.FlatStyle = "Flat"
$btnShortcut.BackColor = [Drawing.Color]::Transparent
$btnShortcut.ForeColor = $textMuted
$btnShortcut.Font = New-Object Drawing.Font("Consolas", 7, [Drawing.FontStyle]::Bold)
$btnShortcut.FlatAppearance.BorderColor = [Drawing.Color]::FromArgb(80,80,90)
$btnShortcut.FlatAppearance.BorderSize = 1
$btnShortcut.Cursor = "Hand"
$container.Controls.Add($btnShortcut)
# Alias novo style
$btnShortcutAlias = $btnShortcut
