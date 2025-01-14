﻿<#
Script made by thelolcoder2007
v1.0 came out on 11-3-2021
current version: 1.0.1
LICENSE: MIT LICENSE.
#>
#load language packs, function DownloadFilesFromRepo is from  Github users @chrisbrownie and @zerotag
function DownloadFilesFromRepo {
	Param(
		[Parameter(Mandatory=$True)]
		[string]$User,

		[Parameter(Mandatory=$True)]
		[string]$Token,

		[Parameter(Mandatory=$True)]
		[string]$Owner,

		[Parameter(Mandatory=$True)]
		[string]$Repository,

		[Parameter(Mandatory=$True)]
		[AllowEmptyString()]
		[string]$Path,

		[Parameter(Mandatory=$True)]
		[string]$DestinationPath
	)

	# Authentication
	$authPair = "$($User):$($Token)";
	$encAuth = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($authPair));
	$headers = @{ Authorization = "Basic $encAuth" };
	
	# REST Building
	$baseUri = "https://api.github.com";
	$argsUri = "repos/$Owner/$Repository/contents/$Path";
	$wr = Invoke-WebRequest -Uri ("$baseUri/$argsUri") -Headers $headers;

	# Data Handler
	$objects = $wr.Content | ConvertFrom-Json
	$files = $objects | where {$_.type -eq "file"} | Select -exp download_url
	$directories = $objects | where {$_.type -eq "dir"}
	
	# Iterate Directory
	$directories | ForEach-Object { 
		DownloadFilesFromRepo -User $User -Token $Token -Owner $Owner -Repository $Repository -Path $_.path -DestinationPath "$($DestinationPath)/$($_.name)"
	}

	# Destination Handler
	if (-not (Test-Path $DestinationPath)) {
		try {
			New-Item -Path $DestinationPath -ItemType Directory -ErrorAction Stop;
		} catch {
			throw "Could not create path '$DestinationPath'!";
		}
	}

	# Iterate Files
	foreach ($file in $files) {
		$fileDestination = Join-Path $DestinationPath (Split-Path $file -Leaf)
		$outputFilename = $fileDestination.Replace("%20", " ");
		try {
			Invoke-WebRequest -Uri "$file" -OutFile "$outputFilename" -ErrorAction Stop -Verbose
			"Grabbed '$($file)' to '$outputFilename'";
		} catch {
			throw "Unable to download '$($file)'";
		}
	}
}
$lang = Read-Host -Prompt "en/nl"
$1 = "S"
$token = "ghp_HIHPplPEM2jWGtxGh5p2ilbgikNdwE0BCO1+$1"
downloadfilesfromrepo -User thelolcoder2007 -Token $token -Owner thelolcoder2007 -Repository newserver.ps1 -Path assets/langs/${lang}.lang.ps1 -DestinationPath $env:Temp\newserver -ErrorAction Stop
$scriptlocation = "$env:Temp\newserver\en.lang.ps1"
. $scriptlocation
Write-Host -Object $loading

#load module posh-SSH (needed for SFTP-1+SSH-1 and SFTP-2)
function modules {
    $1 = install-Module -Name posh-SSH -Scope CurrentUser -Force
}

#ask which server.properties function you want to call
function server-properties_questions {
    $srvProp = Read-Host -Prompt $serverpropertiesquestion 
    if ($srvProp -eq $serverpropertiessimple) {
        server-properties_simple
    }
    elseif ($srvProp -eq $serverpropertiesadvanced) {
        server-properties_advanced
    }
    elseif ($srvProp -eq $serverpropertiesnone) {
        $global:serverPRT = Read-Host -Prompt $serverPRTquestion
        Write-Host -Object $serverPRTskip
    }else{
    Write-Host -Object $serverprtfault
}
}

#make an server.properties file, for people who know what an server.properties is and how that works.
function server-properties_advanced {
    function ask{
        param ([string]$vraag, [string]$defVal, [string]$propVal)
        $returnval = Read-Host -Prompt $vraag
        $returnval = RET $returnval $defVal
        Add-Content $env:TEMP\newserver\server.properties "$propVal=$returnval"
    }
    function RET {
        param ([string]$nu, [string]$def)
        if ($nu -eq "") {
            return $def
        }else{
            return $nu
        }
    }
    Write-Host -Object $fillIn
    ask "spawnprotection(def=16)" 16 "spawn-protection"
    ask "max tick time(def=60000)" 60000 "max-tick-time"
    $qport = Read-Host "query port (def=25565)($sameAsServerPRT)"
    $qport = RET $qport 25565
    Add-Content $env:TEMP\newserver\server.properties "query.port=$qport"
    Add-Content $env:TEMP\newserver\server.properties "generator-settings="
    ask "force gamemode (def=false)" $false "force-gamemode"
    ask "allow nether(def=true)" $true "allow-nether"
    ask "force whitelist(def=false)" $false "enforce-whitelist"
    ask "gamemode(def=survival)" "survival" "gamemode"
    ask "broadcast console to ops(def=true)" $true "broadcast-console-to-ops"
    ask "enable query(def=false)" $false "enable-query"
    ask "player idle time(def=0)" 0 "player-idle-timeout"
    ask "difficulty(def=easy)" "easy" "difficulty"
    ask "broadcast rcon to ops(def=true)" $true "broadcast-rcon-to-ops"
    ask "spawn mobs(def=true)" $true "spawn-monsters"
    ask "operator permission level (def=4)" 4 "op-permission-level"
    ask "pvp(def=true)" $true "pvp"
    ask "snooper enabled(def=true)" $true "snooper-enabled"
    ask "leveltype(def=default)" "default" "level-type"
    ask "hardcore(def=false)" $false  "hardcore"
    ask "enable command blocks(def=true)" $true "enable-command-block"
    ask "network compression threshold(def=256)" 256 "network-compression-threshold"
    ask "max players(def=10)" 10 "max-players"
    ask "max world size(def=29999984)" 29999984 "max-world-size"
    $resPack1 = Read-Host -Prompt "URL resource pack sha-1"
    Add-Content $env:TEMP\newserver\server.properties "resource-pack-sha1"
    $rconprt = $qport + 20
    Add-Content $env:TEMP\newserver\server.properties "rcon.port"
    $global:serverPRT = $qport
    try {
        $1 = $qport / 20
    }
    catch {
        Write-Host -Object "that was not a number"
        break
    }
    Add-Content $env:TEMP\newserver\server.properties "server-port=$global:serverPRT"
    $srvIP = Read-Host -Prompt "server ip"
    Add-Content $env:TEMP\newserver\server.properties "server-ip"
    ask "spawn NPC's(def=true)" $true "spawn-npcs"
    ask "allow flight(def=true)" $true "allow-flight"
    ask "world folder(def=world)" "world" "level-name"
    ask "view distance(def=10)" 10 "view-distance"
    $resPack = Read-Host -Prompt "URL resource pack"
    Add-Content $env:TEMP\newserver\server.properties "resource-pack="
    ask "animal spawn(def=true)" $true "spawn-animals"
    ask "whitelist(def=false)" $false "white-list"
    $rconPass = Read-Host -Prompt "rcon password"
    Add-Content $env:TEMP\newserver\server.properties "rcon.password"
    ask "generate structures(def=true)" $true "generate-structures"
    ask "online mode(def=true)" $true "online-mode"
    ask "maxBuildHeight(def=256)" 256 "max-build-height"
    $seed = Read-Host -Prompt "world seed"
    Add-Content $env:TEMP\newserver\server.properties "level-seed=$seed"
    ask "prevent proxy connection(def=false)" $false "prevent-proxy-connections"
    ask "use native transport(def=true)" $true "use-native-transport"
    $Motd = read-host -prompt "what is your MOTD"
    Add-Content $env:TEMP\newserver\server.properties "motd=$motd"
    ask "enable rcon(def=false)" $false "enable-rcon"
}

#make an server.properties file, for people who have no idea how server.properties works.
function server-properties_simple {
    function RET {
        param ([string]$nu, [string]$def)
        if ($nu -eq "") {
            return $def
        }else{
            return $nu
        }
    }
    function add {
        param ([string]$toWrite)
        Add-Content "$env:TEMP\newserver\server.properties" $toWrite
    }
    add -toWrite "spawn-protection=16"
    add -toWrite "max-tick-time=60000"
    $qport = read-host -Prompt $qportquestion
    $qport = RET $qport 25565
    add -toWrite $qport
    add -toWrite "generator-settings="
    add -toWrite "force-gamemode=false"
    add -toWrite "allow-nether=true"
    add -toWrite "enforce-whitelist=false"
    $gamemode = Read-Host $gamemodequestion
    $gmtest = 0, 1, 2, 3
    if (!$gmtest -ccontains $gamemode) {
    Write-Host -Object $gamemodefault
    break
    }elseif ($gamemode -eq 0) {
        $gamemode = "survival"
    }elseif ($gamemode -eq 1) {
        $gamemode = "creative"
    }elseif ($gamemode -eq 2 ) {
        $gamemode = "adventure"
    }else{
        $gamemode = "spectator"
    }
    add -toWrite "gamemode=$gamemode"
    add -toWrite "broadcast-console-to-ops=true"
    add -toWrite "enable-query=true"
    add -toWrite "player-idle-timeout=0"
    add -toWrite "difficiculty=easy"
    add -toWrite "broadcast-rcon-to-ops=true"
    add -toWrite "spawn-monsters=true"
    add -toWrite "op-permission-level=4"
    add -toWrite "pvp=true"
    add -toWrite "snooper-enabled=true"
    add -toWrite "level-type=default"
    add -toWrite "hardcore=false"
    add -toWrite "enable-command-block=false"
    add -toWrite "network-compression-threshold=256"
    add -toWrite "max-players=20"
    add -toWrite "max-world-size=29999984"
    add -toWrite "resource-pack-sha1="
    add -toWrite "function-permission-level=2"
    $rconPRT = $qport + 20
    add -toWrite "rcon.port=$rconPRT"
    $global:serverPRT = $qport
    add -toWrite "server-port=$global:serverPRT"
    add -toWrite "server-ip="
    add -toWrite "spawn-npcs=true"
    add -toWrite "allow-flight=true"
    add -toWrite "level-name=world"
    add -toWrite "view-distance=10"
    add -toWrite "resource-pack="
    add -toWrite "spawn-animals=true"
    add -toWrite "white-list=false"
    $rconPass = Read-Host -Prompt $rconpassquestion
    add -toWrite "rcon.password=$rconPass"
    add -toWrite "generate-structures=true"
    add -toWrite "online-mode=true"
    add -toWrite "max-build-height=256"
    add -toWrite "level-seed="
    add -toWrite "prevent-proxy-connections=false"
    add -toWrite "use-native-transport=true"
    add -toWrite "motd=A minecraft server"
    add -toWrite "enable-rcon=true"
}

#ask if you want to make an eula.txt file
function eula-txt_questions {
    $eulaAsk = Read-Host -Prompt $eula_txtquestion
    if ($eulaAsk -eq $y) {
        Write-Host -Object $eulatxtskip
    }elseif ($eulaAsk -eq $n) {
        eula-txt
    }else{
        Write-Host $eula_txtfault
        break
    }
}

#make an eula.txt file, for uploading in sftp-1+ssh-1
function eula-txt {
    Add-Content $env:TEMP\newserver\eula.txt "eula=true"
}

#ask if you want to add an start.sh file to your server
function start-sh_questions {
    $question = Read-Host -Prompt $start_shquestion
    if ($question -eq $n) {
        start-sh
    }elseif ($question -eq $y) {
        Write-Host -Object $start_shskip
    }else{
        Write-Host -Object $start_shfault
        break
    }
}

#make an start.sh file, for uploading in sftp-2
function start-sh {
    Add-Content C:\Users\Thomas\AppData\Local\Temp\newserver\start.sh -Value '#!bin/sh'
    Add-Content C:\Users\Thomas\AppData\Local\Temp\newserver\start.sh -Value 'BINDIR="$(dirname "$(readlink -fn "$0")")"'
    Add-Content C:\Users\Thomas\AppData\Local\Temp\newserver\start.sh -Value 'cd "$bindir"'
}

#ask if you want to download server.jar files
function download_questions {
    $downld = Read-Host -Prompt $downloadquestion
    if ($downld -eq $n) {
        download
    }elseif ($downld -eq $y) {
        Write-Host -Object $serverjarskipped
    }else{
        Write-Host -Object $serverjarfault
    }
}

#download the server.jar files
function download {
    function comd {
        param ([int]$ID, [string]$comd)
        $1 = Invoke-SSHCommand -SessionId $ID -Command $comd
    }
    $minecraftversions = "1.12", "1.12.1", "1.12.2", "1.13", "1.13.1","1.13.2","1.14","1.14.1","1.14.2","1.14.3","1.14.4","1.15","1.15.1","1.15.2","1.16","1.16.1","1.16.2","1.16.3","1.16.4","1.16.5","latest"
    $jarfiles = "bukkit","forge","clean","spigot"
    $jarfile = Read-Host -Prompt $jarfilechoose
    $version = Read-Host -Prompt "${minecraftversionquestion} ${minecraftversions}"
    if ($minecraftversions -ccontains $version) {
        if ($jarfiles -ccontains $jarfile) {
            if ($jarfile -eq "forge") {
                DownloadFilesFromRepo -User thelolcoder2007 -Token $env:token -Owner thelolcoder2007 -Repository newserver.ps1 -Path "assets/forge/latest/server/" -DestinationPath $env:temp\newserver\server
                $global:f=$true
            }else{
                DownloadFilesFromRepo -User thelolcoder2007 -Token $env:token -Owner thelolcoder2007 -Repository newserver.ps1 -Path "assets/${jarfile}/${version}" -DestinationPath $env:temp\newserver\
                Add-Content -Path $env:temp\newserver\start.sh -Value "java -Xmx1024M -Xms1024M -jar server.jar"
                $global:f=$false
            }
        }else{
            Write-Host -Object $notvalidvalue
            break
        }
    }else{
        Write-Host -Object $notvalidvalue
        break
    }
}

#make folder and upload server.properties, eula.txt and start.sh
function sftp+ssh {
    function comd {
        param ([int]$ID, [string]$comd)
        $1 = Invoke-SSHCommand -SessionId $ID -Command $comd 
    }
    $computername =  Read-Host $compnamequestion
    $usernameTOcomp = Read-Host "${usernamequestion}${computername}?"
    Write-Host -Object $passwordtwice
    $1 = New-SFTPSession -Port 22 -ComputerName $computername -Credential $usernameTOcomp -Force -AcceptKey
    $1 = New-SSHSession -Port 22 -ComputerName $computername -Credential $usernameTOcomp -Force -AcceptKey
    $1 = comd 0 "cd ~"
    $1 = comd 0 "mkdir $global:serverPRT"
    $1 = Set-SFTPFile -SessionId 0 -RemotePath ./$global:serverPRT -LocalFile $env:TEMP\newserver\eula.txt -Overwrite
    $1 = Set-SFTPFile -SessionId 0 -RemotePath ./$global:serverPRT -LocalFile $env:TEMP\newserver\server.properties -Overwrite
    $1 = Set-SFTPFile -SessionId 0 -RemotePath ./$global:serverPRT/ -LocalFile $env:TEMP\newserver\start.sh -Overwrite
    if ($global:f) {
        $1 = Set-SFTPFile -SessionId 0 -RemotePath ./$global:serverPRT/ -LocalFile $env:TEMP\newserver\server\* -Overwrite
    }else{
        $1 = Set-SFTPFile -SessionId 0 -RemotePath ./$global:serverPRT/ -LocalFile $env:temp\newserver\server.jar -Overwrite
    }
}

#clean up, so you can't see what happened at your computer
function clean-up {
    $1 = Remove-SFTPSession -SessionId 0
    $1 = Remove-Item -Path $env:TEMP\newserver\*.*
    $1 = Remove-Item -Path $env:TEMP\newserver\* -Force
    $1 = Remove-SSHSession -SessionId 0
}

#call all functions one by one
function call {
    modules
    server-properties_questions
    eula-txt_questions
    start-sh_questions
    download_questions
    sftp+ssh
    clean-up
}

#run the whole script
call

<#
MOSCOW list:

MUST

SHOULD
Add folder check at remote PATCH

COULD
Add all versions to choose from MINOR

WOULD
Make GUI MAJOR
Add RSS feed (or something) to auto-update the server versions MAJOR

#>
