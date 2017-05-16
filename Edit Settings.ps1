# Update settings file
$SettingsLocation = $env:LOCALAPPDATA + "\TslGame\Saved\Config\WindowsNoEditor\"
$SettingsFile = $SettingsLocation+'GameUserSettings.ini'
$SettingsFileBackup = $SettingsLocation+'GameUserSettings.bak.ini'
# Settings region
$LastConvertedMouseSensitivity = 'LastConvertedMouseSensitivity=0.030000'
$ScreenScale = 'ScreenScale=100.000000'
$Gamma = 'Gamma=65.000000'
$MouseSensitivity = 'MouseSensitivity=58.000000'
$FrameRateLimit = 'FrameRateLimit=100.000000'
$FullscreenMode = 'FullscreenMode=1'

# Load settings file
$SettingsFileContents = (Get-Content $SettingsFile)
$NewSettingsFileContents = $SettingsFileContents
# Replace current values with new values
$NewSettingsFileContents = $NewSettingsFileContents -replace '(?=LastConvertedMouseSensitivity).+?\=\d+.\d+', $LastConvertedMouseSensitivity
$NewSettingsFileContents = $NewSettingsFileContents -replace '(?=ScreenScale).+?\=\d+.\d+', $ScreenScale
$NewSettingsFileContents = $NewSettingsFileContents -replace '(?=Gamma).+?\=\d+.\d+', $Gamma
$NewSettingsFileContents = $NewSettingsFileContents -replace '(?=MouseSensitivity).+?\=\d+.\d+', $MouseSensitivity
$NewSettingsFileContents = $NewSettingsFileContents -replace '(?=FrameRateLimit).+?\=\d+.\d+', $FrameRateLimit

$NewSettingsFileContents = $NewSettingsFileContents -replace '(?=FullscreenMode).+?\=\d', $FullscreenMode

write-output 'Preview new settings'
$NewSettingsFileContents | Out-GridView -Wait
write-output 'Show new settings'
Compare-Object -referenceObject $SettingsFileContents -differenceObject $NewSettingsFileContents -caseSensitive | Out-GridView -Wait

#Save Changes
$title = "Save Changes"
$message = "Do you want to save your new settings?"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
    "Saves all the changes to the GameUserSettings file."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
    "No changes made to GameUserSettings file."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$result = $host.ui.PromptForChoice($title, $message, $options, 0) 

switch ($result)
{
	0 {$SettingsFileContents | Set-Content $SettingsFileBackup;$NewSettingsFileContents | Set-Content $SettingsFile}
	1 {"No changes made"}
}
pause