# Jarvis installer for Windows 10/11 (64-bit). Installs the built release, not source.
# Usage, in PowerShell:  irm https://huy100408.github.io/jarvis-install/install.ps1 | iex
# Windows PowerShell 5.1 compatible; keep this file ASCII only.
& {
    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    $site = 'https://huy100408.github.io/jarvis-install'
    $pythonUrl = 'https://www.python.org/ftp/python/3.12.10/python-3.12.10-amd64.exe'

    function Find-JarvisPython {
        $found = @()
        $launcher = Get-Command py.exe -ErrorAction SilentlyContinue
        if ($launcher) {
            try {
                $path = & $launcher.Source -3.12 -c "import sys; print(sys.executable)"
                if ($LASTEXITCODE -eq 0 -and $path) { $found += "$path".Trim() }
            } catch { }
        }
        $found += (Join-Path $env:LOCALAPPDATA 'Programs\Python\Python312\python.exe')
        $found += (Join-Path $env:ProgramFiles 'Python312\python.exe')
        foreach ($candidate in $found) {
            if ($candidate -and (Test-Path -LiteralPath $candidate)) { return $candidate }
        }
        return $null
    }

    $temp = Join-Path ([IO.Path]::GetTempPath()) ('jarvis-' + [Guid]::NewGuid().ToString('N'))
    try {
        if (-not [Environment]::Is64BitOperatingSystem) { throw 'Jarvis needs 64-bit Windows 10 or 11.' }
        if ([Environment]::OSVersion.Version.Major -lt 10) { throw 'Jarvis needs Windows 10 or 11.' }
        New-Item -ItemType Directory -Force -Path $temp | Out-Null

        if (-not (Find-JarvisPython)) {
            Write-Host 'Downloading Python 3.12...'
            $setup = Join-Path $temp 'python-3.12-setup.exe'
            Invoke-WebRequest -UseBasicParsing -Uri $pythonUrl -OutFile $setup
            $signature = Get-AuthenticodeSignature -LiteralPath $setup
            if ($signature.Status -ne 'Valid' -or $signature.SignerCertificate.Subject -notlike '*Python Software Foundation*') {
                throw 'The Python download failed its signature check. Nothing was installed.'
            }
            Write-Host 'Installing Python 3.12 for this user (no administrator rights needed)...'
            $run = Start-Process -FilePath $setup -Wait -PassThru -ArgumentList '/quiet', 'InstallAllUsers=0', 'PrependPath=0', 'Include_test=0', 'Include_doc=0', 'Include_launcher=0', 'Shortcuts=0'
            if ($run.ExitCode -ne 0 -or -not (Find-JarvisPython)) {
                throw "Python 3.12 could not be installed (code $($run.ExitCode)). Install it from python.org, then run this installer again."
            }
        }

        Write-Host 'Downloading Jarvis...'
        $latest = Invoke-RestMethod -Uri "$site/latest-windows.json?t=$([DateTime]::UtcNow.Ticks)"
        $zip = Join-Path $temp 'jarvis.zip'
        Invoke-WebRequest -UseBasicParsing -Uri "$site/$($latest.file)" -OutFile $zip
        $hash = (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToLower()
        if ($hash -ne "$($latest.sha256)".ToLower()) { throw 'Download check failed (hash mismatch). Nothing was installed.' }
        Expand-Archive -LiteralPath $zip -DestinationPath (Join-Path $temp 'pkg') -Force

        $package = Join-Path $temp 'pkg\Jarvis'
        & (Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe') -NoProfile -ExecutionPolicy Bypass `
            -File (Join-Path $package 'scripts\jarvis.ps1') install-package $package
        if ($LASTEXITCODE -ne 0) { throw 'The installation did not finish. Read the message above, then run this installer again.' }
    } catch {
        Write-Host $_.Exception.Message -ForegroundColor Red
    } finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue }
    }
}
