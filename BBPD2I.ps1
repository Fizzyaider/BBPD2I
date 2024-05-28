# BBPD2I (Basic Bitch Payday 2 Installer) v1.2[BETA] By Fizzyaider
# I skipped dinner to make the original script lol

# Variable declaration section here essentially
$RARDirectory = $PSScriptRoot

$drives = Get-PSDrive -PSProvider FileSystem

$PDDrive = ""

echo 'Drives detected, attempting to automatically find payday 2 installation'

# What this for loop will do is go through all of the drives that are found within the system and then proceed to 
for ($DIndex = 0; $DIndex -lt $drives.count; $DIndex++)
{
    if ([string]$drives[$DIndex] -eq "C")
    {
        if ($(Test-Path -Path "$([string]$drives[$DIndex]):\Program Files (x86)\Steam\steamapps\common\PAYDAY 2") -eq "True")
        {
            echo "Payday 2 installation found! Drive: $([string]$drives[$DIndex])"
            $PDDrive = $([string]$drives[$DIndex])
            break
        }
        
    } else {
        if ($(Test-Path -Path "$([string]$drives[$DIndex]):\SteamLibrary\steamapps\common\PAYDAY 2") -eq "True")
        {
            echo "Payday 2 installation found! Drive: $([string]$drives[$DIndex])"
            $PDDrive = $([string]$drives[$DIndex])
            break
        }
    }
}

$PI = "$($PDDrive):\SteamLibrary\steamapps\common\PAYDAY 2\mods"
$PDMD = "$($PDDrive):\SteamLibrary\steamapps\common\PAYDAY 2"
[int]$score = 0
$MODNames = ".\tmp\BeardLib.zip",".\tmp\vanhudplus.zip",".\tmp\WD2MainMenu.zip"
$OKFiles = "base","downloads","logs","saves"


# In this section - BBPD2I is searching to find if "WSOCK2.dll" is present on the payday 2 installation folder, if it is not
# then what will happen is that it will send a download web request to the URL that contains the WSOCK2.dll file
if ($(Test-Path "$($PDDrive):\SteamLibrary\steamapps\common\PAYDAY 2\WSOCK32.dll") -eq $false)
{
    echo "SuperBLT library file not found, downloading to payday 2 installation . . ."
    Invoke-WebRequest "https://sblt-update.znix.xyz/pd2update/download/get.php?src=homepage&id=payday2bltwsockdll" -OutFile "$($PDMD)\WSOCK32.dll"
}

# This little bit here copies all of the folders within the payday 2 installation 'mod' folder if they are present and then place them into a
# '.tmp' folder within the directory that the installation script is running in. This serves as a backup in the case that BBPD2I does not
# work properly.
for ($CIndex = 0; $CIndex -lt $OKFiles.count; $CIndex++)
{
	# Write-Host (-join("$PI","\","$($OKFiles[$CIndex])"))
	Copy-Item -Path "$(-join("$PI","\","$($OKFiles[$CIndex])"))" -Destination ".\tmp" -Recurse
}

Remove-Item -Path $PI -Recurse
Remove-Item -Path $PI\..\assets\mod_overrides -Recurse

mkdir $PI

for ($CIndex = 0; $CIndex -lt $OKFiles.count; $CIndex++)
{
	Copy-Item -Path "$(-join(".\tmp\","$($OKFiles[$CIndex])"))" -Destination "$(-join("$PI","\","$($OKFiles[$CIndex])"))" -Recurse
}

for ($index = 0; $index -lt $MODNames.count; $index++)
{
	echo $(Test-Path $MODNames[$index])
	if ($(Test-Path $MODNames[$index]) -eq "True")
	{
		$score++
	}
}

echo "$score" > "./log.txt"

if ($score -eq 3)
{
	echo "Success!" > "./log.txt"
	for ($i = 0; $i -lt 2; $i++)
	{
		Expand-Archive -Path $MODNames[$i] -DestinationPath "$PI"
	}
	Expand-Archive -Path $MODNames[2] -DestinationPath "$PI\..\"
}
else
{
	Invoke-WebRequest "https://github.com/simon-wh/PAYDAY-2-BeardLib/releases/download/5.0/BeardLib.zip" -OutFile .\tmp\BeardLib.zip
	Invoke-WebRequest "https://storage.modworkshop.net/mods/files/download_42171_1515775719_77dc4b1ce7bbf2b299ab9fe6dd208ab5.zip?response-content-disposition=attachment;filename=WD2%20Main%20Menu.zip" -OutFile .\tmp\WD2MainMenu.zip
	Invoke-WebRequest "https://gitlab.com/steam-test1/alternative-updates/-/raw/main/update/vanhudplus.zip" -OutFile .\tmp\vanhudplus.zip
	
	for ($i = 0; $i -lt 2; $i++)
	{
		Expand-Archive -Path $MODNames[$i] -DestinationPath "$PI"
	}
	Expand-Archive -Path $MODNames[2] -DestinationPath "$PI\..\"
}