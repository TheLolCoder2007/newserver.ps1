$sshsessions = Get-SSHSession
$SFTPSessions = Get-SFTPSession
if ($sshsessions.Connected) {
Remove-SSHSession -SessionId 0
}
if ($SFTPSessions.Connected) {
Remove-SFTPSession -SessionId 0
}