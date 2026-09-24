Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- CYBERPUNK NEON THEME ---
$bgMain      = [Drawing.Color]::FromArgb(2,2,10)        # #02020a deep void
$bgHeader    = [Drawing.Color]::FromArgb(5,7,18)        # #050712
$bgCard      = [Drawing.Color]::FromArgb(6,8,20)        # #060814
$bgCardAlt   = [Drawing.Color]::FromArgb(8,10,28)       # #080A1C
$bgInput     = [Drawing.Color]::FromArgb(0,0,0)         # pure black
$border      = [Drawing.Color]::FromArgb(0,240,255)     # cyan neon
$borderDim   = [Drawing.Color]::FromArgb(30,60,80)      # dim cyan border
$borderLight = [Drawing.Color]::FromArgb(0,200,220)
$textMain    = [Drawing.Color]::FromArgb(226,255,253)   # neon white
$textMuted   = [Drawing.Color]::FromArgb(120,220,240)   # cyan muted
$textFaint   = [Drawing.Color]::FromArgb(80,100,120)
$violet      = [Drawing.Color]::FromArgb(0,240,255)     # cyan primary
$violetHover = [Drawing.Color]::FromArgb(0,210,235)
$violetDeep  = [Drawing.Color]::FromArgb(0,170,200)
$indigo      = [Drawing.Color]::FromArgb(112,0,255)     # purple accent
$pink        = [Drawing.Color]::FromArgb(255,0,168)     # neon pink
$pinkHover   = [Drawing.Color]::FromArgb(230,0,150)
$red         = [Drawing.Color]::FromArgb(255,0,64)      # neon red
$redBg       = [Drawing.Color]::FromArgb(20,0,10)
$redBorder   = [Drawing.Color]::FromArgb(80,0,30)
$amber       = [Drawing.Color]::FromArgb(255,208,0)     # cyber yellow
$amberHover  = [Drawing.Color]::FromArgb(255,225,40)
$emerald     = [Drawing.Color]::FromArgb(0,240,255)     # cyan success
$cyanGlow    = [Drawing.Color]::FromArgb(0,240,255)

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

# Linha laser topo - cyan + pink
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

# --- Header ---
$headerPanel = New-Object Windows.Forms.Panel
$headerPanel.Location = New-Object Drawing.Point(0,3)
$headerPanel.Size = New-Object Drawing.Size(460, 72)
$headerPanel.BackColor = $bgHeader
$Form.Controls.Add($headerPanel)

# linha neon embaixo do header
$headerLine = New-Object Windows.Forms.Panel
$headerLine.Location = New-Object Drawing.Point(0,71)
$headerLine.Size = New-Object Drawing.Size(460,1)
$headerLine.BackColor = [Drawing.Color]::FromArgb(40,240,255)
$headerPanel.Controls.Add($headerLine)

$logoPanel = New-Object Windows.Forms.Panel
$logoPanel.Location = New-Object Drawing.Point(20, 14)
$logoPanel.Size = New-Object Drawing.Size(44, 44)
$logoPanel.BackColor = [Drawing.Color]::Black
$logoPanel.BorderStyle = "FixedSingle"
$headerPanel.Controls.Add($logoPanel)

$lblLogo = New-Object Windows.Forms.Label
$lblLogo.Text = "O"
$lblLogo.Font = New-Object Drawing.Font("Consolas", 16, [Drawing.FontStyle]::Bold)
$lblLogo.ForeColor = $violet
$lblLogo.Location = New-Object Drawing.Point(0,0)
$lblLogo.Size = New-Object Drawing.Size(44,44)
$lblLogo.TextAlign = "MiddleCenter"
$logoPanel.Controls.Add($lblLogo)

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

# --- Card countdown CYBER ---
$cardTop = New-Object Windows.Forms.Panel
$cardTop.Location = New-Object Drawing.Point(16, 88)
$cardTop.Size = New-Object Drawing.Size(420, 176)
$cardTop.BackColor = $borderDim
$Form.Controls.Add($cardTop)

$cardInner = New-Object Windows.Forms.Panel
$cardInner.Location = New-Object Drawing.Point(1,1)
$cardInner.Size = New-Object Drawing.Size(418,174)
$cardInner.BackColor = $bgCard
$cardTop.Controls.Add($cardInner)

# cross brackets - top left etc are simulated with small panels
$lblCountdownTitle = New-Object Windows.Forms.Label
$lblCountdownTitle.Text = "T-MINUS // TEMPO RESTANTE"
$lblCountdownTitle.ForeColor = $violet
$lblCountdownTitle.Font = New-Object Drawing.Font("Consolas", 7, [Drawing.FontStyle]::Bold)
$lblCountdownTitle.Location = New-Object Drawing.Point(0, 14)
$lblCountdownTitle.Size = New-Object Drawing.Size(418, 14)
$lblCountdownTitle.TextAlign = "MiddleCenter"
$cardInner.Controls.Add($lblCountdownTitle)

$lblCountdown = New-Object Windows.Forms.Label
$lblCountdown.Text = "00:00:00"
$lblCountdown.Font = New-Object Drawing.Font("Consolas", 36, [Drawing.FontStyle]::Bold)
$lblCountdown.ForeColor = [Drawing.Color]::White
$lblCountdown.Location = New-Object Drawing.Point(0, 34)
$lblCountdown.Size = New-Object Drawing.Size(418, 66)
$lblCountdown.TextAlign = "MiddleCenter"
$cardInner.Controls.Add($lblCountdown)

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

# --- Presets CYBER ---
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

# --- Tempo personalizado CYBER ---
$lblCustom = New-Object Windows.Forms.Label
$lblCustom.Text = "TEMPO PERSONALIZADO  // CUSTOM_INPUT"
$lblCustom.Font = New-Object Drawing.Font("Consolas", 8, [Drawing.FontStyle]::Bold)
$lblCustom.ForeColor = $pink
$lblCustom.Location = New-Object Drawing.Point(20, 348)
$lblCustom.AutoSize = $true
$Form.Controls.Add($lblCustom)

function New-TimeGroup($x, $label, $max, $isAccent) {
    $p = New-Object Windows.Forms.Panel
    $p.Location = New-Object Drawing.Point($x, 370)
    $p.Size = New-Object Drawing.Size(130, 86)
    $p.BackColor = [Drawing.Color]::Black
    $p.BorderStyle = "FixedSingle"
    if ($isAccent) { $p.BackColor = [Drawing.Color]::FromArgb(5,10,20) }
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
    $borderPanel = New-Object Windows.Forms.Panel
    $borderPanel.Location = New-Object Drawing.Point(0,0)
    $borderPanel.Size = New-Object Drawing.Size(130,86)
    $borderPanel.BackColor = [Drawing.Color]::Transparent
    $borderPanel.BorderStyle = "FixedSingle"
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
$numMins.Value = 30

# --- Botoes acao CYBER ---
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

# --- Logica ---
$script:endTime = $null
$script:totalSeconds = 0
$script:scheduled = $false

$timer = New-Object Windows.Forms.Timer
$timer.Interval = 1000

function Update-CmdPreview {
    $sec = [int]$numHours.Value * 3600 + [int]$numMins.Value * 60 + [int]$numSecs.Value
    $lblCmd.Text = "shutdown /s /t $sec /f"
}
$numHours.Add_ValueChanged({ Update-CmdPreview })
$numMins.Add_ValueChanged({ Update-CmdPreview })
$numSecs.Add_ValueChanged({ Update-CmdPreview })
Update-CmdPreview

function Format-Time($s) {
    $h = [int][Math]::Floor($s/3600)
    $m = [int][Math]::Floor(($s%3600)/60)
    $sec = [int]($s%60)
    return ("{0:D2}:{1:D2}:{2:D2}" -f $h,$m,$sec)
}

function Set-Feedback($msg, $color) {
    $lblFeedback.Text = $msg
    if ($color) { $lblFeedback.ForeColor = $color } else { $lblFeedback.ForeColor = $textMuted }
}

function Set-Badge($isScheduled) {
    if ($isScheduled) {
        $badge.Text = "  Agendado"
        $badge.BackColor = [Drawing.Color]::FromArgb(60,30,10)
        $badge.ForeColor = [Drawing.Color]::FromArgb(251,191,36)
    } else {
        $badge.Text = "  Ocioso"
        $badge.BackColor = [Drawing.Color]::FromArgb(24,24,27)
        $badge.ForeColor = $textMuted
    }
}

$timer.Add_Tick({
    if ($null -eq $script:endTime) { return }
    $remaining = [Math]::Ceiling(($script:endTime - (Get-Date)).TotalSeconds)
    if ($remaining -lt 0) { $remaining = 0 }
    $lblCountdown.Text = Format-Time $remaining
    if ($script:totalSeconds -gt 0) {
        $pct = [Math]::Round((($script:totalSeconds - $remaining) / $script:totalSeconds)*100)
        if ($pct -lt 0) { $pct=0 }; if ($pct -gt 100) { $pct=100 }
        $progress.Width = [int](382 * $pct / 100)
    }
    if ($remaining -le 0) {
        $timer.Stop()
        Set-Feedback "Desligando..." $emerald
    } elseif ($remaining -eq 60) {
        [System.Media.SystemSounds]::Exclamation.Play()
    }
})

$btnSchedule.Add_Click({
    $sec = [int]$numHours.Value * 3600 + [int]$numMins.Value * 60 + [int]$numSecs.Value
    if ($sec -le 0) { Set-Feedback "Defina um tempo maior que 0" $red; return }
    try {
        $out = shutdown /s /t $sec /f 2>&1
        if ($LASTEXITCODE -ne 0) { throw $out }
        $script:totalSeconds = $sec
        $script:endTime = (Get-Date).AddSeconds($sec)
        $script:scheduled = $true
        $timer.Start()
        $lblCountdown.Text = Format-Time $sec
        $progress.Width = 0
        Set-Badge $true
        $btnSchedule.Enabled = $false
        $btnSchedule.BackColor = [Drawing.Color]::FromArgb(39,39,42)
        $btnCancel.BackColor = $redBg
        Set-Feedback ("Desligamento agendado em " + (Format-Time $sec)) $emerald
    } catch {
        Set-Feedback ("Erro: $($_.Exception.Message)") $red
    }
})

$btnCancel.Add_Click({
    try {
        $out = shutdown /a 2>&1
        if ($LASTEXITCODE -ne 0 -and $out -notmatch "332|Nenhum|There is no") {
        }
        $timer.Stop()
        $script:endTime = $null
        $script:scheduled = $false
        $lblCountdown.Text = "00:00:00"
        $progress.Width = 0
        Set-Badge $false
        $btnSchedule.Enabled = $true
        $btnSchedule.BackColor = $violet
        if ($out -match "332|Nenhum|There is no|no shutdown") {
            Set-Feedback "Nenhum agendamento ativo para cancelar" $red
        } else {
            Set-Feedback "Desligamento cancelado" $emerald
        }
    } catch {
        Set-Feedback "Nenhum agendamento ativo" $red
        $timer.Stop()
        $script:endTime = $null
        $script:scheduled = $false
        Set-Badge $false
        $btnSchedule.Enabled = $true
        $btnSchedule.BackColor = $violet
    }
})

$btnNow.Add_Click({
    $confirm = [Windows.Forms.MessageBox]::Show("Desligar o PC agora?", "Confirmar", [Windows.Forms.MessageBoxButtons]::YesNo, [Windows.Forms.MessageBoxIcon]::Warning)
    if ($confirm -eq "Yes") {
        shutdown /s /t 0 /f
    }
})

$btnShortcut.Add_Click({
    try {
        $desktop = [Environment]::GetFolderPath("Desktop")
        $shortcutPath = Join-Path $desktop "Desligar PC.lnk"
        $target = $PSCommandPath
        if (-not $target) { $target = Join-Path $PSScriptRoot "DesligarPC.ps1" }
        $WshShell = New-Object -ComObject WScript.Shell
        $sc = $WshShell.CreateShortcut($shortcutPath)
        $sc.TargetPath = "powershell.exe"
        $sc.Arguments = "-ExecutionPolicy Bypass -WindowStyle Normal -File `"$target`""
        $sc.WorkingDirectory = Split-Path $target
        $sc.Description = "Painel Desligar PC - Premium"
        $sc.IconLocation = "shell32.dll,27"
        $sc.Save()
        Set-Feedback ("Icone criado em: $shortcutPath") $emerald
        $btnShortcut.Text = "Criado!"
        Start-Sleep -Milliseconds 1500
        $btnShortcut.Text = "Criar icone na Area de Trabalho   -   1 clique"
    } catch {
        Set-Feedback ("Erro ao criar atalho: $($_.Exception.Message)") $red
    }
})

$btnSchedule.Add_MouseEnter({ if ($btnSchedule.Enabled) { $btnSchedule.BackColor = $violetHover } })
$btnSchedule.Add_MouseLeave({ if ($btnSchedule.Enabled) { $btnSchedule.BackColor = $violet } })
$btnCancel.Add_MouseEnter({ $btnCancel.BackColor = [Drawing.Color]::FromArgb(60,20,20) })
$btnCancel.Add_MouseLeave({ $btnCancel.BackColor = $redBg })
$btnNow.Add_MouseEnter({ $btnNow.BackColor = $amberHover })
$btnNow.Add_MouseLeave({ $btnNow.BackColor = $amber })

$Form.Add_FormClosing({
    if ($script:scheduled) {
    }
})

[void]$Form.ShowDialog()

