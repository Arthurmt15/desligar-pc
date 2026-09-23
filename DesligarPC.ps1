Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Cores (tema dark otimizado) ---
$bgMain   = [Drawing.Color]::FromArgb(24,24,27)   # zinc-900
$bgCard   = [Drawing.Color]::FromArgb(39,39,42)   # zinc-800
$bgInput  = [Drawing.Color]::FromArgb(9,9,11)     # zinc-950
$border   = [Drawing.Color]::FromArgb(63,63,70)   # zinc-700
$textMain = [Drawing.Color]::White
$textMuted= [Drawing.Color]::FromArgb(161,161,170) # zinc-400
$violet   = [Drawing.Color]::FromArgb(124,58,237) # violet-600
$violetHover = [Drawing.Color]::FromArgb(109,40,217)
$red      = [Drawing.Color]::FromArgb(220,38,38)
$amber    = [Drawing.Color]::FromArgb(217,119,6)

$Form = New-Object Windows.Forms.Form
$Form.Text = "Desligar PC - Painel"
$Form.Size = New-Object Drawing.Size(440, 620)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = $bgMain
$Form.ForeColor = $textMain
$Form.FormBorderStyle = "FixedDialog"
$Form.MaximizeBox = $false
$Form.Font = New-Object Drawing.Font("Segoe UI", 9)
$Form.Icon = [Drawing.SystemIcons]::Shield

# --- Header ---
$lblTitle = New-Object Windows.Forms.Label
$lblTitle.Text = "Desligar PC"
$lblTitle.Font = New-Object Drawing.Font("Segoe UI Semibold", 14)
$lblTitle.Location = New-Object Drawing.Point(20, 18)
$lblTitle.AutoSize = $true
$Form.Controls.Add($lblTitle)

$lblSub = New-Object Windows.Forms.Label
$lblSub.Text = "Agende o desligamento automatico"
$lblSub.ForeColor = $textMuted
$lblSub.Location = New-Object Drawing.Point(20, 42)
$lblSub.AutoSize = $true
$Form.Controls.Add($lblSub)

$badge = New-Object Windows.Forms.Label
$badge.Text = "  Ocioso"
$badge.BackColor = [Drawing.Color]::FromArgb(39,39,42)
$badge.ForeColor = $textMuted
$badge.Font = New-Object Drawing.Font("Segoe UI", 8, [Drawing.FontStyle]::Bold)
$badge.Location = New-Object Drawing.Point(320, 24)
$badge.Size = New-Object Drawing.Size(90, 24)
$badge.TextAlign = "MiddleCenter"
$Form.Controls.Add($badge)

# --- Card countdown ---
$panelTop = New-Object Windows.Forms.Panel
$panelTop.Location = New-Object Drawing.Point(16, 72)
$panelTop.Size = New-Object Drawing.Size(400, 140)
$panelTop.BackColor = $bgCard
$Form.Controls.Add($panelTop)

$lblCountdownTitle = New-Object Windows.Forms.Label
$lblCountdownTitle.Text = "TEMPO RESTANTE"
$lblCountdownTitle.ForeColor = $textMuted
$lblCountdownTitle.Font = New-Object Drawing.Font("Segoe UI", 7, [Drawing.FontStyle]::Bold)
$lblCountdownTitle.Location = New-Object Drawing.Point(0, 14)
$lblCountdownTitle.Size = New-Object Drawing.Size(400, 14)
$lblCountdownTitle.TextAlign = "MiddleCenter"
$panelTop.Controls.Add($lblCountdownTitle)

$lblCountdown = New-Object Windows.Forms.Label
$lblCountdown.Text = "00:00:00"
$lblCountdown.Font = New-Object Drawing.Font("Consolas", 36, [Drawing.FontStyle]::Bold)
$lblCountdown.Location = New-Object Drawing.Point(0, 32)
$lblCountdown.Size = New-Object Drawing.Size(400, 60)
$lblCountdown.TextAlign = "MiddleCenter"
$panelTop.Controls.Add($lblCountdown)

$lblCmd = New-Object Windows.Forms.Label
$lblCmd.Text = 'shutdown /s /t 0 /f'
$lblCmd.Font = New-Object Drawing.Font("Consolas", 7)
$lblCmd.ForeColor = $textMuted
$lblCmd.BackColor = $bgInput
$lblCmd.Location = New-Object Drawing.Point(90, 98)
$lblCmd.Size = New-Object Drawing.Size(220, 18)
$lblCmd.TextAlign = "MiddleCenter"
$panelTop.Controls.Add($lblCmd)

$progress = New-Object Windows.Forms.ProgressBar
$progress.Location = New-Object Drawing.Point(16, 124)
$progress.Size = New-Object Drawing.Size(368, 6)
$progress.Style = "Continuous"
$progress.ForeColor = $violet
$panelTop.Controls.Add($progress)

# --- Presets ---
$lblPresets = New-Object Windows.Forms.Label
$lblPresets.Text = "Atalhos rapidos"
$lblPresets.Location = New-Object Drawing.Point(20, 226)
$lblPresets.AutoSize = $true
$Form.Controls.Add($lblPresets)

$presetVals = @(15,30,60,120)
$presetTexts = @("15 min","30 min","1 hora","2 horas")
for ($i=0; $i -lt 4; $i++) {
    $btn = New-Object Windows.Forms.Button
    $btn.Text = $presetTexts[$i]
    $btn.Tag = $presetVals[$i]
    $btn.Location = New-Object Drawing.Point((20 + $i*100), 248)
    $btn.Size = New-Object Drawing.Size(90, 32)
    $btn.FlatStyle = "Flat"
    $btn.BackColor = $bgCard
    $btn.ForeColor = $textMain
    $btn.FlatAppearance.BorderColor = $border
    $btn.Cursor = "Hand"
    $btn.Add_Click({
        $mins = [int]$this.Tag
        $numHours.Value = [Math]::Floor($mins/60)
        $numMins.Value = $mins % 60
        $numSecs.Value = 0
        Update-CmdPreview
    })
    $Form.Controls.Add($btn)
}

# --- Inputs custom ---
$lblCustom = New-Object Windows.Forms.Label
$lblCustom.Text = "Tempo personalizado"
$lblCustom.Location = New-Object Drawing.Point(20, 292)
$lblCustom.AutoSize = $true
$Form.Controls.Add($lblCustom)

function New-TimeGroup($x, $label, $max) {
    $p = New-Object Windows.Forms.Panel
    $p.Location = New-Object Drawing.Point($x, 314)
    $p.Size = New-Object Drawing.Size(122, 78)
    $p.BackColor = $bgInput
    $p.BorderStyle = "FixedSingle"
    $lbl = New-Object Windows.Forms.Label
    $lbl.Text = $label
    $lbl.Font = New-Object Drawing.Font("Segoe UI", 7, [Drawing.FontStyle]::Bold)
    $lbl.ForeColor = $textMuted
    $lbl.Location = New-Object Drawing.Point(0,8)
    $lbl.Size = New-Object Drawing.Size(122,14)
    $lbl.TextAlign = "MiddleCenter"
    $p.Controls.Add($lbl)
    $num = New-Object Windows.Forms.NumericUpDown
    $num.Location = New-Object Drawing.Point(22, 30)
    $num.Size = New-Object Drawing.Size(78, 28)
    $num.Font = New-Object Drawing.Font("Segoe UI Semibold", 14)
    $num.BackColor = $bgInput
    $num.ForeColor = $textMain
    $num.BorderStyle = "None"
    $num.TextAlign = "Center"
    $num.Minimum = 0
    $num.Maximum = $max
    $num.Value = 0
    $p.Controls.Add($num)
    return @{ Panel=$p; Num=$num }
}

$gH = New-TimeGroup 20 "HORAS" 99
$gM = New-TimeGroup 152 "MINUTOS" 59
$gS = New-TimeGroup 284 "SEGUNDOS" 59
$Form.Controls.Add($gH.Panel)
$Form.Controls.Add($gM.Panel)
$Form.Controls.Add($gS.Panel)
$numHours = $gH.Num
$numMins  = $gM.Num
$numSecs  = $gS.Num
$numMins.Value = 30

# --- Botoes acao ---
$btnSchedule = New-Object Windows.Forms.Button
$btnSchedule.Text = "Agendar desligamento"
$btnSchedule.Location = New-Object Drawing.Point(20, 410)
$btnSchedule.Size = New-Object Drawing.Size(392, 44)
$btnSchedule.FlatStyle = "Flat"
$btnSchedule.BackColor = $violet
$btnSchedule.ForeColor = [Drawing.Color]::White
$btnSchedule.Font = New-Object Drawing.Font("Segoe UI Semibold", 10)
$btnSchedule.FlatAppearance.BorderSize = 0
$btnSchedule.Cursor = "Hand"
$Form.Controls.Add($btnSchedule)

$btnCancel = New-Object Windows.Forms.Button
$btnCancel.Text = "Cancelar"
$btnCancel.Location = New-Object Drawing.Point(20, 462)
$btnCancel.Size = New-Object Drawing.Size(190, 38)
$btnCancel.FlatStyle = "Flat"
$btnCancel.BackColor = $bgCard
$btnCancel.ForeColor = $textMuted
$btnCancel.FlatAppearance.BorderColor = $border
$btnCancel.Enabled = $false
$btnCancel.Cursor = "Hand"
$Form.Controls.Add($btnCancel)

$btnNow = New-Object Windows.Forms.Button
$btnNow.Text = "Desligar agora"
$btnNow.Location = New-Object Drawing.Point(222, 462)
$btnNow.Size = New-Object Drawing.Size(190, 38)
$btnNow.FlatStyle = "Flat"
$btnNow.BackColor = $amber
$btnNow.ForeColor = [Drawing.Color]::White
$btnNow.FlatAppearance.BorderSize = 0
$btnNow.Cursor = "Hand"
$Form.Controls.Add($btnNow)

$lblFeedback = New-Object Windows.Forms.Label
$lblFeedback.Text = ""
$lblFeedback.ForeColor = $textMuted
$lblFeedback.Location = New-Object Drawing.Point(20, 510)
$lblFeedback.Size = New-Object Drawing.Size(392, 18)
$lblFeedback.TextAlign = "MiddleCenter"
$lblFeedback.Font = New-Object Drawing.Font("Segoe UI", 8)
$Form.Controls.Add($lblFeedback)

$btnShortcut = New-Object Windows.Forms.Button
$btnShortcut.Text = "Criar icone na Area de Trabalho"
$btnShortcut.Location = New-Object Drawing.Point(20, 534)
$btnShortcut.Size = New-Object Drawing.Size(392, 32)
$btnShortcut.FlatStyle = "Flat"
$btnShortcut.BackColor = [Drawing.Color]::White
$btnShortcut.ForeColor = [Drawing.Color]::FromArgb(24,24,27)
$btnShortcut.FlatAppearance.BorderSize = 0
$btnShortcut.Cursor = "Hand"
$Form.Controls.Add($btnShortcut)

# --- Lógica ---
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
    $h = [Math]::Floor($s/3600)
    $m = [Math]::Floor(($s%3600)/60)
    $sec = $s%60
    return ("{0:D2}:{1:D2}:{2:D2}" -f $h,$m,$sec)
}

function Set-Feedback($msg, $color) {
    $lblFeedback.Text = $msg
    if ($color) { $lblFeedback.ForeColor = $color } else { $lblFeedback.ForeColor = $textMuted }
}

function Set-Badge($isScheduled) {
    if ($isScheduled) {
        $badge.Text = "  Agendado"
        $badge.BackColor = [Drawing.Color]::FromArgb(120,53,15)
        $badge.ForeColor = [Drawing.Color]::FromArgb(251,191,36)
    } else {
        $badge.Text = "  Ocioso"
        $badge.BackColor = $bgCard
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
        $progress.Value = $pct
    }
    if ($remaining -le 0) {
        $timer.Stop()
        Set-Feedback "Desligando..." ([Drawing.Color]::FromArgb(52,211,153))

    } elseif ($remaining -eq 60) {
        [System.Media.SystemSounds]::Exclamation.Play()
    }
})

$btnSchedule.Add_Click({
    $sec = [int]$numHours.Value * 3600 + [int]$numMins.Value * 60 + [int]$numSecs.Value
    if ($sec -le 0) { Set-Feedback "Defina um tempo maior que 0" ([Drawing.Color]::FromArgb(248,113,113)); return }
    try {
        # shutdown /s /t X /f
        $out = shutdown /s /t $sec /f 2>&1
        if ($LASTEXITCODE -ne 0) { throw $out }
        $script:totalSeconds = $sec
        $script:endTime = (Get-Date).AddSeconds($sec)
        $script:scheduled = $true
        $timer.Start()
        $lblCountdown.Text = Format-Time $sec
        $progress.Value = 0
        Set-Badge $true
        $btnCancel.Enabled = $true
        $btnSchedule.Enabled = $false
        $btnSchedule.BackColor = [Drawing.Color]::FromArgb(63,63,70)
        Set-Feedback ("Desligamento agendado em " + (Format-Time $sec)) ([Drawing.Color]::FromArgb(52,211,153))
    } catch {
        Set-Feedback ("Erro: $($_.Exception.Message)") ([Drawing.Color]::FromArgb(248,113,113))
    }
})

$btnCancel.Add_Click({
    try {
        $out = shutdown /a 2>&1
        # shutdown /a retorna erro se nao houver agendamento, mas consideramos sucesso
        $timer.Stop()
        $script:endTime = $null
        $script:scheduled = $false
        $lblCountdown.Text = "00:00:00"
        $progress.Value = 0
        Set-Badge $false
        $btnCancel.Enabled = $false
        $btnSchedule.Enabled = $true
        $btnSchedule.BackColor = $violet
        Set-Feedback "Desligamento cancelado" ([Drawing.Color]::FromArgb(52,211,153))
    } catch {
        Set-Feedback "Nenhum agendamento ativo" ([Drawing.Color]::FromArgb(248,113,113))
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
        # Se rodando como ps1, criar atalho que chama powershell com Bypass
        $WshShell = New-Object -ComObject WScript.Shell
        $sc = $WshShell.CreateShortcut($shortcutPath)
        $sc.TargetPath = "powershell.exe"
        $sc.Arguments = "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$target`""
        $sc.WorkingDirectory = Split-Path $target
        $sc.Description = "Painel Desligar PC - Standalone leve"
        $sc.IconLocation = "shell32.dll,27"
        $sc.Save()
        Set-Feedback ("Icone criado em: $shortcutPath") ([Drawing.Color]::FromArgb(52,211,153))
        $btnShortcut.Text = "Criado!"
        Start-Sleep -Milliseconds 1500
        $btnShortcut.Text = "Criar icone na Area de Trabalho"
    } catch {
        Set-Feedback ("Erro ao criar atalho: $($_.Exception.Message)") ([Drawing.Color]::FromArgb(248,113,113))
    }
})

$btnSchedule.Add_MouseEnter({ if ($btnSchedule.Enabled) { $btnSchedule.BackColor = $violetHover } })
$btnSchedule.Add_MouseLeave({ if ($btnSchedule.Enabled) { $btnSchedule.BackColor = $violet } })

# Interceptar fechamento: não cancela agendamento
$Form.Add_FormClosing({
    # se tiver agendamento, apenas avisa
    if ($script:scheduled) {
        # não cancela automaticamente
    }
})

[void]$Form.ShowDialog()
