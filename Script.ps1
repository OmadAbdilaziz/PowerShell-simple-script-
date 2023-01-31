Install-WindowsFeature -name Web-Server -IncludeManagementTools
Remove-Item -Path 'C:\inetpub\wwwroot\iisstart.htm'

$connectTestResult = Test-NetConnection -ComputerName omadstoracc.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"omadstoracc.file.core.windows.net`" /user:`"localhost\omadstoracc`" /pass:`"PX2iFWkuLlRihabrue8qttYGJR0dbJVk67QKYPqud2ahAfVLwmJX33QGk6n6/m3tMQJXOowBNSAH+AStxkfQYg==`""
    # Mount the drive
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\omadstoracc.file.core.windows.net\webcontent" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}
Copy-Item -Path 'Z:\Production\Webcontent\*' -Destination 'C:\inetpub\wwwroot' -Recurse
