$Title = "Connection settings for WSUS"
$Author = "Neale Lonslow"
$PluginVersion = 1.0
$Header = "Connection Settings"
$Comments = "Connection Plugin for connecting to a WSUS Server"
$Display = "None"
$PluginCategory = "WSUS"

# Start of Settings
# Please Specify the address (and optional port) of the vCenter server to connect to [servername(:port)]
$Server = "";
# End of Settings

# Update settings where there is an override
$Server = Get-vCheckSetting $Title "Server" $Server

# Setup plugin-specific language table
$pLang = DATA {
   ConvertFrom-StringData @' 
      connOpen  = Connecting to WSUS Server
      connError = Unable to connect to WSUS, please ensure you have altered the server address and port correctly.
      custAttr  = Doing stuff, init.

'@
}
# Override the default (en) if it exists in lang directory
Import-LocalizedData -BaseDirectory ($ScriptPath + "\lang") -BindingVariable pLang -ErrorAction SilentlyContinue

# Path to credentials file which is automatically created if needed
# $Credfile = $ScriptPath + "\Windowscreds.xml"

$ServerName = ($Server -Split ":")[0]
$Port = 8530;
if (($server -split ":")[1]) {
   $Port = ($server -split ":")[1]
}


Write-CustomOut $pLang.connOpen;

$WSUSServer = Get-WsusServer -Name $ServerName -PortNumber $Port

if ($null -eq $WSUSServer) {
    Write-Error $pLang.connError;
}

Write-CustomOut $pLang.custAttr;
Write-Host $pLang.custAttr -ForegroundColor Blue

# Get Groups
$Groups = $WSUSServer.GetComputerTargetGroups();

<#
Write-CustomOut $pLang.collectVM
$VM = Get-VM | Sort-Object Name
Write-CustomOut $pLang.collectHost
$VMH = Get-VMHost | Sort-Object Name
Write-CustomOut $pLang.collectCluster
$Clusters = Get-Cluster | Sort-Object Name
Write-CustomOut $pLang.collectDatastore
$Datastores = Get-Datastore | Sort-Object Name
Write-CustomOut $pLang.collectDVM
$FullVM = Get-View -ViewType VirtualMachine | Where-Object {-not $_.Config.Template}
Write-CustomOut $pLang.collectTemplate 
$VMTmpl = Get-Template
Write-CustomOut $pLang.collectDVIO
$ServiceInstance = get-view ServiceInstance
Write-CustomOut $pLang.collectAlarm
$alarmMgr = get-view $ServiceInstance.Content.alarmManager
Write-CustomOut $pLang.collectDHost
$HostsViews = Get-View -ViewType hostsystem
Write-CustomOut $pLang.collectDCluster
$clusviews = Get-View -ViewType ClusterComputeResource
Write-CustomOut $pLang.collectDDatastore
$storageviews = Get-View -ViewType Datastore
Write-CustomOut $pLang.collectAlarms
$valarms = $alarmMgr.GetAlarm($null) | Select-Object value, @{N="name";E={(Get-View -Id $_).Info.Name}}
#>
