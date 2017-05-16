###
## Edit settings file of PlayerUnknown's Battlegrounds
##
##
##
###

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

# Settings regex
$Settings = @(
('(?=LastConvertedMouseSensitivity).+?\=\d+.\d+', $LastConvertedMouseSensitivity),
('(?=ScreenScale).+?\=\d+.\d+', $ScreenScale),
('(?=Gamma).+?\=\d+.\d+', $Gamma),
('(?=MouseSensitivity).+?\=\d+.\d+', $MouseSensitivity),
('(?=FrameRateLimit).+?\=\d+.\d+', $FrameRateLimit),
('(?=FullscreenMode).+?\=\d', $FullscreenMode)
)

####
## Don't change anything past this point
####
# Load settings file
$SettingsFileContents = (Get-Content $SettingsFile)
$NewSettingsFileContents = $SettingsFileContents
# Replace current values with new values
foreach ($setting in $settings)
{
	$NewSettingsFileContents = $NewSettingsFileContents -replace $setting
}

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