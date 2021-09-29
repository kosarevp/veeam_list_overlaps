Import-Module -Name 'Veeam.Backup.PowerShell' -DisableNameChecking
$BSessions = Get-VBRBackupSession

while ($BSessions) {
    $CurSession, $BSessions = $BSessions

    $Overlaps = @()
    foreach ($Session in $BSessions) {
        if ($CurSession.CreationTime -ge $Session.CreationTime -and $CurSession.CreationTime -le $Session.EndTime -or $CurSession.EndTime -ge $Session.CreationTime -and $CurSession.EndTime -le $Session.EndTime)
        {
            $Overlaps += $Session
        }
    }
    if ($Overlaps) {
        Write-Host ($CurSession.Name + ' (start: ' + $CurSession.CreationTime + ', end: ' + $CurSession.EndTime + ') overlaps with following backup sessions:')
        foreach ($item in $Overlaps) {
            Write-Host '-->', $item.Name, 'start:', $item.CreationTime, 'end:', $item.EndTime    
        }
    }
}
