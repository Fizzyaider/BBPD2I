# BBPD2I (Basic Bitch Payday 2 Installer) V1.0 By Fizzyaider
# I skipped dinner to make this script lol

$RARDirectory = $PSScriptRoot
$PDDrive = Read-Host "Please enter the letter of the drive that Payday 2 is installed on [PLEASE ENSURE THAT STEAM IS INSTALLED AT THE ROOT OF THE DRIVE]"
$PI = "$($PDDrive):\SteamLibrary\steamapps\common\PAYDAY 2\mods"
[int]$score = 0
echo $RARDirectory > "./log.txt"
$MODNames = ".\tmp\BeardLib.zip",".\tmp\vanhudplus.zip",".\tmp\WD2MainMenu.zip"
$OKFiles = "base","downloads","logs","saves"

mkdir ".\tmp"

for ($CIndex = 0; $CIndex -lt $OKFiles.count; $CIndex++)
{
	Write-Host (-join("$PI","\","$($OKFiles[$CIndex])"))
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

Remove-Item -Path ".\tmp" -Recurse