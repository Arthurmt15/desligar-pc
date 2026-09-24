#Requires -Version 5.1
<#
.SYNOPSIS
    Logica do painel - timers, formatacao e eventos
.DESCRIPTION
    Controla countdown, executa shutdown /s /t, cancela com /a,
    cria atalho .lnk e gerencia hover/animacoes.
    Depende de UI.ps1 (controles) e Theme.ps1 (cores).
#>

# --- Estado global ---
$script:endTime = $null       # DateTime de termino
$script:totalSeconds = 0      # total inicial para progresso
$script:scheduled = $false    # flag se ha agendamento ativo

# Persistencia para sobreviver ao fechar/reabrir (Windows shutdown persiste)
$scheduleFile = Join-Path $env:TEMP "desligar_neon_schedule.json"
function Save-Schedule {
    try {
        if ($script:scheduled -and $script:endTime) {
            @{ total=$script:totalSeconds; end=$script:endTime.ToString('o') } | ConvertTo-Json | Set-Content -LiteralPath $scheduleFile -Encoding UTF8
        } else { if (Test-Path $scheduleFile) { Remove-Item $scheduleFile -Force } }
    } catch {}
}
function Load-Schedule {
    try {
        if (Test-Path $scheduleFile) {
            $j = Get-Content $scheduleFile -Raw | ConvertFrom-Json
            $end = [DateTime]::Parse($j.end)
            $rem = [Math]::Ceiling(($end - (Get-Date)).TotalSeconds)
            if ($rem -gt 0) {
                # verifica se shutdown ainda esta agendado (tenta /a com dry-run via query)
                # Windows nao tem query, entao confia no arquivo se rem >0
                $script:totalSeconds = [int]$j.total
                $script:endTime = $end
                $script:scheduled = $true
                return $rem
            } else { Remove-Item $scheduleFile -Force -ErrorAction SilentlyContinue }
        }
    } catch {}
    return 0
}

$timer = New-Object Windows.Forms.Timer
$timer.Interval = 1000 # tick a cada segundo

# --- Helpers ---

# Atualiza preview do comando shutdown com tempo atual
function Update-CmdPreview {
    $sec = [int]$numHours.Value * 3600 + [int]$numMins.Value * 60 + [int]$numSecs.Value
    $lblCmd.Text = "shutdown /s /t $sec /f"
}
# Conecta mudancas nos NumericUpDown ao preview
$numHours.Add_ValueChanged({ Update-CmdPreview })
$numMins.Add_ValueChanged({ Update-CmdPreview })
$numSecs.Add_ValueChanged({ Update-CmdPreview })
Update-CmdPreview

# Formata segundos em HH:MM:SS (corrigido: cast int para D2)
function Format-Time($s) {
    $h = [int][Math]::Floor($s/3600)
    $m = [int][Math]::Floor(($s%3600)/60)
    $sec = [int]($s%60)
    return ("{0:D2}:{1:D2}:{2:D2}" -f $h,$m,$sec)
}

# Exibe mensagem de feedback com cor
function Set-Feedback($msg, $color) {
    $lblFeedback.Text = $msg
    if ($color) { $lblFeedback.ForeColor = $color } else { $lblFeedback.ForeColor = $textMuted }
}

# Atualiza badge OCIOSO <-> AGENDADO (neon v2 style: verde #00ff66 quando ativo)
function Set-Badge($isScheduled) {
    if ($isScheduled) {
        $badge.Text = "  AGENDADO"
        $badge.BackColor = [Drawing.Color]::FromArgb(0,40,20)
        $badge.ForeColor = $emerald
        try { $badge.FlatAppearance.BorderColor = $emerald } catch {}
    } else {
        $badge.Text = "  OCIOSO"
        $badge.BackColor = [Drawing.Color]::FromArgb(255,255,255,12)
        $badge.ForeColor = $textMuted
    }
}

# --- Timer tick - atualiza countdown e progresso ---
$timer.Add_Tick({
    if ($null -eq $script:endTime) { return }
    $remaining = [Math]::Ceiling(($script:endTime - (Get-Date)).TotalSeconds)
    if ($remaining -lt 0) { $remaining = 0 }
    $lblCountdown.Text = Format-Time $remaining
    # progresso 0-100% -> largura da barra (container novo 400px)
    if ($script:totalSeconds -gt 0) {
        $pct = [Math]::Round((($script:totalSeconds - $remaining) / $script:totalSeconds)*100)
        if ($pct -lt 0) { $pct=0 }; if ($pct -gt 100) { $pct=100 }
        $progress.Width = [int](400 * $pct / 100)
    }
    if ($remaining -le 0) {
        $timer.Stop()
        $script:scheduled = $false
        $script:endTime = $null
        Save-Schedule
        Set-Feedback "Desligando..." $emerald
    } elseif ($remaining -eq 60) {
        # alerta sonoro 1 min antes
        [System.Media.SystemSounds]::Exclamation.Play()
    }
})

# --- Acao: Agendar desligamento ---
$btnSchedule.Add_Click({
    $sec = [int]$numHours.Value * 3600 + [int]$numMins.Value * 60 + [int]$numSecs.Value
    if ($sec -le 0) { Set-Feedback "Defina um tempo maior que 0" $red; return }
    try {
        $out = shutdown /s /t $sec /f 2>&1
        if ($LASTEXITCODE -ne 0) { throw $out }
        $script:totalSeconds = $sec
        $script:endTime = (Get-Date).AddSeconds($sec)
        $script:scheduled = $true
        Save-Schedule
        $timer.Start()
        $lblCountdown.Text = Format-Time $sec
        $progress.Width = 0
        Set-Badge $true
        $btnSchedule.Enabled = $false
        $btnSchedule.BackColor = [Drawing.Color]::FromArgb(39,39,42)
        Set-Feedback ("Desligamento agendado em " + (Format-Time $sec)) $emerald
    } catch {
        Set-Feedback ("Erro: $($_.Exception.Message)") $red
    }
})

# --- Acao: Cancelar agendamento ---
$btnCancel.Add_Click({
    try {
        $out = shutdown /a 2>&1
        $timer.Stop()
        $script:endTime = $null
        $script:scheduled = $false
        Save-Schedule
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
        Save-Schedule
        Set-Badge $false
        $btnSchedule.Enabled = $true
        $btnSchedule.BackColor = $violet
    }
})

# --- Acao: Desligar agora ---
$btnNow.Add_Click({
    $confirm = [Windows.Forms.MessageBox]::Show("Desligar o PC agora?", "Confirmar", [Windows.Forms.MessageBoxButtons]::YesNo, [Windows.Forms.MessageBoxIcon]::Warning)
    if ($confirm -eq "Yes") {
        shutdown /s /t 0 /f
    }
})

# --- Acao: Criar atalho .lnk na area de trabalho ---
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
        $sc.Description = "Painel Desligar PC - Neon Protocol"
        $sc.IconLocation = "shell32.dll,27"
        $sc.Save()
        Set-Feedback ("Icone criado em: $shortcutPath") $emerald
        $btnShortcut.Text = "Criado!"
        Start-Sleep -Milliseconds 1500
        $btnShortcut.Text = "CRIAR ICONE  // 1-CLICK NEON_LINK"
    } catch {
        Set-Feedback ("Erro ao criar atalho: $($_.Exception.Message)") $red
    }
})

# --- Hover effects neon ---
$btnSchedule.Add_MouseEnter({ if ($btnSchedule.Enabled) { $btnSchedule.BackColor = $violetHover } })
$btnSchedule.Add_MouseLeave({ if ($btnSchedule.Enabled) { $btnSchedule.BackColor = $violet } })
$btnCancel.Add_MouseEnter({ $btnCancel.BackColor = [Drawing.Color]::FromArgb(60,20,20) })
$btnCancel.Add_MouseLeave({ $btnCancel.BackColor = [Drawing.Color]::Black })
$btnNow.Add_MouseEnter({ $btnNow.BackColor = $amberHover })
$btnNow.Add_MouseLeave({ $btnNow.BackColor = $amber })

# --- Restore ao abrir (corrige bug: zerava ao reabrir mesmo com agendamento) ---
$remRestore = Load-Schedule
if ($remRestore -gt 0) {
    $lblCountdown.Text = Format-Time $remRestore
    if ($script:totalSeconds -gt 0) {
        $pct = [Math]::Round((($script:totalSeconds - $remRestore)/$script:totalSeconds)*100)
        if ($pct -lt 0) { $pct=0 }; if ($pct -gt 100) { $pct=100 }
        $progress.Width = [int](400 * $pct / 100)
    }
    Set-Badge $true
    $btnSchedule.Enabled = $false
    $btnSchedule.BackColor = [Drawing.Color]::FromArgb(39,39,42)
    $timer.Start()
    Set-Feedback ("Restaurado: " + (Format-Time $remRestore) + " restantes") $emerald
}

# Fechamento - mantem agendamento ativo se houver
$Form.Add_FormClosing({
    if ($script:scheduled) {
        # nao cancela automaticamente, deixa shutdown agendado no sistema
        Save-Schedule
    }
})
