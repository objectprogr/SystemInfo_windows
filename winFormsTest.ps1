#TODO: split code to few files

Add-Type -AssemblyName System.Windows.Forms

#Functions
function GetSystemInfo{
    $ComputerName = $env:COMPUTERNAME
    $System = Get-CimInstance -Class Win32_ComputerSystem -ComputerName $ComputerName
    $labelSystemInfo.Text =  $Title
    $labelSystemInfo.Text += $System | Format-List -Property *  | Out-String
}

#Variables
$ComputerName = $env:COMPUTERNAME
$SystemInfo = {
    $Date = Get-Date
    $Title = 'System informations - ' + $Date
   GetSystemInfo $Title
}
#TODO: -ComputerName change static string to value from textbox
$SoftwareInfo = {
    $Software =  Get-WmiObject Win32_product -ComputerName $ComputerName
    $labelSystemInfo.Text = $Software | Format-List -Property Name,
                                                        Vendor,
                                                        Version | Out-String
}
$NetworkAdapters = {
    $Adapters = Get-CimInstance -Class Win32_NetworkAdapter -ComputerName $ComputerName
    $labelSystemInfo.Text = $Adapters | Format-List -Property DeviceID,
                                                                Name,
                                                                Manufacturer,
                                                                MACAddress,
                                                                Speed,
                                                                PhysicalAdapter | Out-String
}
$NetworkSettings ={
    $Network = Get-CimInstance -Class Win32_NetworkAdapterConfiguration -ComputerName $ComputerName
    $labelSystemInfo.Text = $Network | Format-List -Property Description,
                                                                DHCPEnabled,
                                                                DNSDomain,
                                                                DHCPServer,
                                                                IPAddress,
                                                                MACAddress,
                                                                ServiceName | Out-String 

}
#TODO: - get address from textbox
#      - change function name
$PingGoogleInfo ={
    $Google = '8.8.8.8'
    $PingGoogle = Test-Connection $Google
    $labelSystemInfo.Text = $PingGoogle | Out-String
}
$PhysicalDriveInfo ={
    $PhyscialDrive = Get-CimInstance -Class Win32_DiskDrive -ComputerName $ComputerName
    $labelSystemInfo.Text = $PhyscialDrive | Format-List -Property DeviceID,FirmwareRevision,Manufacturer,Model,MediaType,
    SerialNumber,InterfaceType,Partitions,@{n="Size";e={[math]::Round($_.Size/1GB,2 )}},TotalCylinders,
    TotalHeads,TotalSectors,TotalTracks,TracksPerCylinderBytePerSector,
    SectorsPerTrack,Capabilities,CapabilityDescriptions,Status | Out-String
}
$LogicalDiskInfo = {
    $LogicalDisk = Get-CimInstance -Class Win32_LogicalDisk -ComputerName $ComputerName
    $labelSystemInfo.Text = $LogicalDisk | Format-List -Property DeviceID,Description,SystemCreationalClassName,@{n="Size";e={[math]::Round($_.Size/1GB,2 )}},Compressed,DriveType,
                                                                FileSystem,VolumeName,ProviderName | Out-String
}
$MotherboardInfo = {
    $Motherboard = Get-CimInstance -Class Win32_BaseBoard -ComputerName $ComputerName
    $labelSystemInfo.Text = $Motherboard | Format-List -Property Status,Name,Manufacturer,SerialNumber, Version | Out-String
}
$OSInfo = {
    
    $OS = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ComputerName
    $labelSystemInfo.Text = $OS | Format-List -Property Caption,BuildNumber,InstallDate,LastBootUpTime,Manufacturer,MUILanguages,OSArchitecture,RegisteredUser,SerialNumber,
                                                    SystemDirectory,SystemDrive,Version | Out-String
    
}
$HotFixeInfo = {
    $HotFixes = Get-HotFix
    $labelSystemInfo.Text = $HotFixes |Format-List -Property PSComputerName, Description,
                                                        HotFixID, InstalledBy, InstalledOn |Out-String
}
$FormIcon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")
$Font = New-Object System.Drawing.Font("Consolas",12,[System.Drawing.FontStyle]::Regular)

#Create form objects
$Form = New-Object System.Windows.Forms.Form
#TODO: rename panel name
$infoPanel = New-Object System.Windows.Forms.Panel
$btnSystemInfo = New-Object System.Windows.Forms.Button
$btnSoftwareInfo = New-Object System.Windows.Forms.Button
$btnNetAdaptersInfo = New-Object System.Windows.Forms.Button
$btnNetworkSettings = New-Object System.Windows.Forms.Button
$btnPingGoogle = New-Object System.Windows.Forms.Button
$btnPhysicalDrive = New-Object System.Windows.Forms.Button
$btnLogicalDisks = New-Object System.Windows.Forms.Button
$btnMotherboradInfo = New-Object System.Windows.Forms.Button
$btnOSInfo = New-Object System.Windows.Forms.Button
$btnHotfixInfo = New-Object System.Windows.Forms.Button
$labelSystemInfo = New-Object System.Windows.Forms.Label

#Form properties
$Form.Text = "Demo"
$Form.Width = 1200
$Form.Height = 800
$Form.Font = $Font
$Form.AutoScroll = $false
$Form.AutoSize = $false
$Form.Opacity = 1
$Form.WindowState = 'Normal'
$Form.SizeGripStyle = 'Hide'
$Form.StartPosition = 'CenterScreen'

#Panel properties
$infoPanel.Location = New-Object System.Drawing.Point(155, 30)
$infoPanel.Size = New-Object System.Drawing.Size(1020, 700)
$infoPanel.BorderStyle = "Fixed3D"
$infoPanel.AutoSize = $false
$infoPanel.AutoScroll = $true
$infoPanel.Font = $Font
$infoPanel.Text = ''

#Controls properties

#------Btn System info--------
$btnSystemInfo.Text = 'System'
$btnSystemInfo.Location = New-Object System.Drawing.Point(5,40)
$btnSystemInfo.Size = New-Object System.Drawing.Size(145,25)
$btnSystemInfo.Add_Click($SystemInfo);
#------Btn Software info--------
$btnSoftwareInfo.Text = 'Software'
$btnSoftwareInfo.Location = New-Object System.Drawing.Point(5,65)
$btnSoftwareInfo.Size = New-Object System.Drawing.Size(145,25)
$btnSoftwareInfo.Add_Click($SoftwareInfo);
#------Btn adapters info--------
$btnNetAdaptersInfo.Text = 'Adapters'
$btnNetAdaptersInfo.Location = New-Object System.Drawing.Point(5,90)
$btnNetAdaptersInfo.Size = New-Object System.Drawing.Size(145,25)
$btnNetAdaptersInfo.Add_Click($NetworkAdapters)
#------Btn net settings info--------
$btnNetworkSettings.Text = 'Network'
$btnNetworkSettings.Location = New-Object System.Drawing.Point(5,115)
$btnNetworkSettings.Size = New-Object System.Drawing.Size(145,25)
$btnNetworkSettings.Add_Click($NetworkSettings)
#------Btn ping google info--------
$btnPingGoogle.Text = 'Ping'
$btnPingGoogle.Location = New-Object System.Drawing.Point(5,140)
$btnPingGoogle.Size = New-Object System.Drawing.Size(145,25)
$btnPingGoogle.Add_Click($PingGoogleInfo)
#------Btn physical drive info--------
$btnPhysicalDrive.Text = 'Physical drive'
$btnPhysicalDrive.Location = New-Object System.Drawing.Point(5,165)
$btnPhysicalDrive.Size = New-Object System.Drawing.Size(145,25)
$btnPhysicalDrive.Add_Click($PhysicalDriveInfo)
#------Btn logical disks info--------
$btnLogicalDisks.Text = 'Logical disk'
$btnLogicalDisks.Location = New-Object System.Drawing.Point(5,190)
$btnLogicalDisks.Size = New-Object System.Drawing.Size(145,25)
$btnLogicalDisks.Add_Click($LogicalDiskInfo)
#------Btn motherboard info--------
$btnMotherboradInfo.Text = 'Motherboard'
$btnMotherboradInfo.Location = New-Object System.Drawing.Point(5,215)
$btnMotherboradInfo.Size = New-Object System.Drawing.Size(145,25)
$btnMotherboradInfo.Add_Click($MotherboardInfo)
#------Btn OS info--------
$btnOSInfo.Text = 'OS info'
$btnOSInfo.Location = New-Object System.Drawing.Point(5,240)
$btnOSInfo.Size = New-Object System.Drawing.Size(145,25)
$btnOSInfo.Add_Click($OSInfo)
#------Btn hotfix info--------
$btnHotfixInfo.Text = 'HotFixes'
$btnHotfixInfo.Location = New-Object System.Drawing.Point(5,265)
$btnHotfixInfo.Size = New-Object System.Drawing.Size(145,25)
$btnHotfixInfo.Add_Click($HotFixeInfo)
#------System info more details Label--------
$labelSystemInfo.Location = New-Object System.Drawing.Point(5, 5)
$labelSystemInfo.Size = New-Object System.Drawing.Size(490, 490)
$labelSystemInfo.AutoSize = $true
$labelSystemInfo.Font = $Font
$labelSystemInfo.Text = ""

$labelTest = New-Object System.Windows.Forms.Label
$labelTest.Text = ''
$labelTest.Location = New-Object System.Drawing.Point(0,5)
$labelTest.Font = $Font
#Form window add controls
$Form.Icon = $FormIcon
$Form.Controls.Add($btnSystemInfo)
$Form.Controls.Add($btnSoftwareInfo)
$Form.Controls.Add($btnNetAdaptersInfo)
$Form.Controls.Add($btnNetworkSettings)
$Form.Controls.Add($btnPingGoogle)
$Form.Controls.Add($btnPhysicalDrive)
$Form.Controls.Add($btnLogicalDisks)
$Form.Controls.Add($btnMotherboradInfo)
$Form.Controls.Add($btnOSInfo)
$Form.Controls.Add($btnHotfixInfo)
$Form.Controls.Add($infoPanel)

#Add controls to panel
#$infoPanel.Controls.Add($txt_ComputerName)
$infoPanel.Controls.Add($labelSystemInfo)
$infoPanel.Controls.Add($labelTest)

#Display form
$Form.ShowDialog()