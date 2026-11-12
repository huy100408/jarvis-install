# Remove Jarvis from this Windows PC completely.
# In PowerShell:  irm https://huy100408.github.io/jarvis-install/uninstall.ps1 | iex
# With options:   & ([scriptblock]::Create((irm https://huy100408.github.io/jarvis-install/uninstall.ps1))) -Yes -KeepData
# Or:             jarvis uninstall [-Yes] [-KeepData] [-DryRun]
#   -KeepData  keep settings, sign-in and saved credentials (a reinstall picks them up)
#   -DryRun    only list what would be removed
# Python 3.12 is left installed: other apps may use it.
# Windows PowerShell 5.1 compatible; keep this file ASCII only.
# No 'exit' here: under irm | iex it would close the user's PowerShell window.
& {
    $ErrorActionPreference = 'Stop'
    $flags = @($args | Where-Object { "$_" -ne '' } | ForEach-Object { "$_".ToLower() -replace '^--', '-' -replace '^-keep-data$', '-keepdata' -replace '^-dry-run$', '-dryrun' -replace '^-y$', '-yes' })
    $yes = $flags -contains '-yes'
    $keep = $flags -contains '-keepdata'
    $dry = $flags -contains '-dryrun'
    foreach ($f in $flags) {
        if (@('-yes', '-keepdata', '-dryrun') -notcontains $f) { Write-Host "Unknown option: $f (use -Yes, -KeepData, -DryRun)"; return }
    }

    $dest = Join-Path $env:LOCALAPPDATA 'Jarvis'
    $uninstallKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Jarvis'
    if (Test-Path -LiteralPath (Join-Path $dest '.jarvis-dev')) {
        Write-Host "$dest is a development copy (.jarvis-dev). Not removing anything."
        return
    }

    $program = @()
    # Only folders that are Jarvis installs (a VERSION file), never a same-named folder.
    foreach ($d in @($dest, "$dest.previous")) {
        if (Test-Path -LiteralPath (Join-Path $d 'VERSION')) { $program += $d }
    }
    $program += (Join-Path $env:LOCALAPPDATA 'Jarvis-logs')
    $program += (Join-Path $env:LOCALAPPDATA 'JarvisInstaller')
    foreach ($folder in @([Environment]::GetFolderPath('Programs'), [Environment]::GetFolderPath('Desktop'))) {
        if ($folder) { $program += (Join-Path $folder 'Jarvis.lnk') }
    }
    $shim = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\jarvis.cmd'
    if ((Test-Path -LiteralPath $shim) -and ((Get-Content -LiteralPath $shim -Raw) -match 'jarvis\.ps1')) { $program += $shim }

    $profileDir = $env:USERPROFILE
    $data = @(
        (Join-Path $profileDir '.jarvis'),
        (Join-Path $profileDir 'Library\Application Support\JARVIS'),
        (Join-Path $profileDir '.config\jarvis')
    )
    # Saved credentials (Windows Credential Manager) written by Jarvis.
    $credentials = @()
    foreach ($line in @(cmdkey /list 2>$null)) {
        # Match on the value, not the label: cmdkey labels are translated.
        if ($line -match '(?:^|\s)(\S*com\.jarvis\S*)\s*$') {
            $credentials += ($Matches[1] -replace '^.*target=', '')
        }
    }

    $targets = $program
    if (-not $keep) { $targets += $data }
    $present = @($targets | Where-Object { Test-Path -LiteralPath $_ })

    Write-Host 'Jarvis uninstaller'
    Write-Host ''
    Write-Host 'Will remove:'
    if ($present.Count -eq 0) { Write-Host '  (no Jarvis files found)' }
    foreach ($p in $present) { Write-Host "  $p" }
    if (Test-Path -LiteralPath $uninstallKey) { Write-Host '  Jarvis entry in Settings > Apps' }
    if ($keep) {
        Write-Host 'Keeping settings, sign-in and saved credentials (-KeepData).'
    } elseif ($credentials.Count -gt 0) {
        Write-Host "  $($credentials.Count) saved Jarvis credential(s) in Credential Manager"
    }
    Write-Host ''

    if ($dry) { Write-Host 'Dry run: nothing was removed.'; return }
    if (-not $yes) {
        $answer = ''
        try { $answer = Read-Host 'Remove Jarvis now? Type yes to continue' } catch {
            Write-Host 'No console to confirm in. Re-run with -Yes. Nothing was removed.'; return
        }
        if ($answer -ne 'yes') { Write-Host 'Cancelled. Nothing was removed.'; return }
    }

    Write-Host 'Stopping Jarvis...'
    Get-CimInstance Win32_Process -Filter "Name = 'python.exe' OR Name = 'pythonw.exe'" -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -and $_.CommandLine -like '*jarvis_server*' } |
        ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
    Start-Sleep -Seconds 2
    Set-Location -LiteralPath $env:TEMP

    $failed = @()
    foreach ($p in $present) {
        try { Remove-Item -LiteralPath $p -Recurse -Force -ErrorAction Stop } catch { $failed += $p }
    }
    if (Test-Path -LiteralPath $uninstallKey) { Remove-Item -LiteralPath $uninstallKey -Recurse -Force -ErrorAction SilentlyContinue }
    if (-not $keep) {
        foreach ($target in $credentials) { cmdkey "/delete:$target" 2>$null | Out-Null }
        # Remove the Library folders Jarvis created, only if nothing else is in them.
        foreach ($empty in @((Join-Path $profileDir 'Library\Application Support'), (Join-Path $profileDir 'Library'))) {
            if ((Test-Path -LiteralPath $empty) -and -not (Get-ChildItem -LiteralPath $empty -Force)) {
                Remove-Item -LiteralPath $empty -Force -ErrorAction SilentlyContinue
            }
        }
    }

    Write-Host ''
    if ($failed.Count -gt 0) {
        Write-Host 'Could not remove (close Jarvis windows and try again):' -ForegroundColor Yellow
        foreach ($p in $failed) { Write-Host "  $p" }
        return
    }
    Write-Host 'Jarvis was removed.' -ForegroundColor Green
    Write-Host 'Python 3.12 was left installed (other apps may use it). Remove it in Settings > Apps if nothing else needs it.'
} @args
