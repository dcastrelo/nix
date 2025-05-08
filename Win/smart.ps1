# 1. Verifica si Chocolatey está instalado
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey no encontrado. Instalando Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey ya está instalado."
}

# 2. Instala smartmontools si no está instalado
if (!(Get-Command smartctl.exe -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando smartmontools..."
    choco install smartmontools -y
} else {
    Write-Host "smartmontools ya está instalado."
}

# 3. Asegura el PATH a smartctl
$env:Path += ";C:\Program Files\smartmontools\bin"
Start-Sleep -Seconds 2

# 4. Define los IDs de atributos S.M.A.R.T. que queremos mostrar
$smartIDs = @{
    "  5" = "Reallocated_Sector_Ct"
    "  9" = "Power_On_Hours"
    "187" = "Reported_Uncorrect"
    "196" = "Reallocated_Event_Count"
    "197" = "Current_Pending_Sector"
    "198" = "Offline_Uncorrectable"
}

# 5. Escanea los discos conectados
$discos = & smartctl --scan

# 6. Itera sobre cada disco
foreach ($linea in $discos) {
    if ($linea -match "(.+)\s+-d\s+(.+)\s+#.*") {
        $dispositivo = $matches[1].Trim()
        $driver = $matches[2].Trim()
        Write-Host "`n--- Consultando $dispositivo ($driver) ---"
        $salida = & smartctl -a -d $driver $dispositivo

        foreach ($id in $smartIDs.Keys) {
            $lineaSMART = $salida | Where-Object { $_ -match "^\s*$id\s+" }
            if ($lineaSMART) {
                $partes = $lineaSMART -split '\s+'
                $valor = $partes[-1]
                Write-Host "$($smartIDs[$id]): $valor"
            } else {
                Write-Host "$($smartIDs[$id]): No encontrado"
            }
        }
    }
}
pause