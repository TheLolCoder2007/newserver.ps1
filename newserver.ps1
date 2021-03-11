<#
Script made by thelolcoder2007
v1.0 came out on ?-?-2021
current version: BETA2.0
LICENSE: MIT LICENSE.
FOR MORE INFO SEE LICENSE IN THE ROOT FROM THIS REPO
#>
#load language packs, function DownloadFilesFromRepo is from @chrisbrownie
function DownloadFilesFromRepo {
Param(
    [string]$Owner,
    [string]$Repository,
    [string]$Path,
    [string]$DestinationPath
    )

    $baseUri = "https://api.github.com/"
    $args = "repos/$Owner/$Repository/contents/$Path"
    $wr = Invoke-WebRequest -Uri $($baseuri+$args)
    $objects = $wr.Content | ConvertFrom-Json
    $files = $objects | where {$_.type -eq "file"} | Select -exp download_url
    $directories = $objects | where {$_.type -eq "dir"}
    
    $directories | ForEach-Object { 
        DownloadFilesFromRepo -Owner $Owner -Repository $Repository -Path $_.path -DestinationPath $($DestinationPath+$_.name)
    }

    
    if (-not (Test-Path $DestinationPath)) {
        # Destination path does not exist, let's create it
        try {
            New-Item -Path $DestinationPath -ItemType Directory -ErrorAction Stop
        } catch {
            throw "Could not create path '$DestinationPath'!"
        }
    }

    foreach ($file in $files) {
        $fileDestination = Join-Path $DestinationPath (Split-Path $file -Leaf)
        try {
            Invoke-WebRequest -Uri $file -OutFile $fileDestination -ErrorAction Stop -Verbose
            "Grabbed '$($file)' to '$fileDestination'"
        } catch {
            throw "Unable to download '$($file.path)'"
        }
    }

}
$lang = Read-Host -Prompt "en/nl"
if ($lang -eq "en") {
    downloadfilesfromrepo -Owner thelolcoder2007 -Repository newserver.ps1 -Path assets/langs/en.lang.ps1 -DestinationPath $env:Temp\newserver
    $scriptlocation = "$env:Temp\newserver\en.lang.ps1"
    . $scriptlocation
}elseif ($lang -eq "nl") {
    downloadfilesfromrepo -Owner thelolcoder2007 -Repository newserver.ps1 -Path assets/langs/nl.lang.ps1 -DestinationPath $env:temp\newserver
    $scriptlocation = "$env:Temp\newserver\nl.lang.ps1"
    . $scriptlocation
}else{
    Write-Host -Object "not a valid value, script will now quit."
    break
}
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

#make folder and upload server.properties & eula.txt
function sftp-1+ssh-1 {
    function comd {
        param ([int]$ID, [string]$comd)
        $1 = Invoke-SSHCommand -SessionId $ID -Command $comd 
    }
    $computername =  Read-Host $compnamequestion
    $usernameTOcomp = Read-Host "${usernamequestion} ${computername}?"
    Write-Host -Object $passwordtwice
    New-SFTPSession -Port 22 -ComputerName $computername -Credential $usernameTOcomp -Force -AcceptKey
    New-SSHSession -Port 22 -ComputerName $computername -Credential $usernameTOcomp -Force -AcceptKey
    comd 0 "cd ~"
    $lsoutput = comd 0 "ls"
    Write-Host $lsoutput
    if (!$lsoutput.Output -ccontains $global:serverPRT) {
        Write-Host -Object $serverprtexists
        break
    }
    $1 = comd 0 "mkdir $global:serverPRT"
    $1 = Set-SFTPFile -SessionId 0 -RemotePath ./$global:serverPRT -LocalFile $env:TEMP\newserver\eula.txt -Overwrite
    $1 = Set-SFTPFile -SessionId 0 -RemotePath ./$global:serverPRT -LocalFile $env:TEMP\newserver\server.properties -Overwrite
}

#ask if you want to download server.jar files
function download_questions {
    $downld = Read-Host -Prompt $downloadquestion
    if ($downld -eq $y) {
        download
    }elseif ($downld -eq $n) {
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
    $jarfile = Read-Host -Prompt $jarfilechoose
    if ($jarfile -eq "spigot") {
        DownloadFilesFromRepo -Owner thelolcoder2007 -Repository newserver.ps1 -Path assets/spigot/spigot-1.16.5.jar -DestinationPath $env:temp\newserver\server
        Add-Content $env:TEMP\newserver\start.sh "java -Xmx1024M -Xms1024M -jar spigot-1.16.5.jar"
    }elseif ($jarfile -eq "bukkit") {
        DownloadFilesFromRepo -Owner thelolcoder2007 -Repository newserver.ps1 -Path assets/bukkit/craftbukkit-1.16.5.jar
        Add-Content $env:TEMP\newserver\start.sh "java -Xmx1024M -Xms1024M -jar craftbukkit-1.16.5.jar"
    }elseif ($jarfile -eq "forge") {
        DownloadFilesFromRepo -Owner "thelolcoder2007" -Repository newserver.ps1 -Path assets/forge/server -DestinationPath $env:temp\newserver\server
        Add-Content -Path $env:temp\newserver\start.sh -Value "java -Xmx1024M -Xms1024M -jar minecraft_server.1.16.5.jar"
    }else{
        Write-Host -Object $notvalidvalue
        break
    }
}

#upload start.sh
function sftp-2 {
    $1 = Set-SFTPFile -SessionId 0 -RemotePath ./$global:serverPRT/ -LocalFile $env:TEMP\newserver\start.sh
    $1 = Set-SFTPFile -SessionId 0 -RemotePath ./$global:serverPRT/ -LocalFile $env:temp\newserver\*.jar
}

#clean up, so you can't see what happened at your computer
function clean-up {
    $1 = Remove-SFTPSession -SessionId 0
    $1 = Remove-Item -Path $env:TEMP\newserver\*.*
    $1 = Remove-SSHSession -SessionId 0
}

#call all functions one by one
function call {
    modules
    server-properties_questions
    eula-txt_questions
    start-sh_questions
    sftp-1+ssh-1
    download_questions
    sftp-2
    clean-up
}

#run the whole script
call

<#requirements for out of beta:
1 Repair forge server

MOSCOW list:

MUST
Repair forge

SHOULD

COULD
Add clean server version

WOULD
Make chosing center for versions of the server
Add RSS feed (or something) to auto-update the server versions

#>
