Write-Host -Object "loading functions & modules, wait a moment..."
function modules {
    $1 = install-Module -Name posh-SSH -Scope CurrentUser
}
function make-folder {
    cd $env:TMP
    $1 = mkdir -Path . -Name newserver
}
function server-properties_questions {
    $srvProp = Read-Host -Prompt "server.properties:simple or advanced?"
    if ($srvProp -eq "simple") {
        server-properties_simple
    }
    elseif ($srvProp -eq "advanced") {
        server-properties_advanced
    }
    elseif ($srvProp -eq "none") {
        $serverPRT = Read-Host -Prompt "wat is je server port?"
        Write-Host -Object "server.properties is geskipt"
    }
}
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
    ask "spawnprotection(def=16)" 16 "spawn-protection"
    ask "max tick time(def=60000)" 60000 "max-tick-time"
    $qport = Read-Host "query port (def=25565)(gelijk aan server port)"
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
        $test1 = $qport / 20
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
    Add-Content $env:TEMP\newserver\server.properties "level-seed"
    ask "prevent proxy connection(def=false)" $false "prevent-proxy-connections"
    ask "use native transport(def=true)" $true "use-native-transport"
    $Motd = read-host -prompt "what is your MOTD"
    Add-Content $env:TEMP\newserver\server.properties "motd=$motd"
    ask "enable rcon(def=false)" $false "enable-rcon"
}
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
    $qport = read-host -Prompt "what is your query port? (it will be the same as the server port)"
    $qport = RET $qport 25565
    add -toWrite $qport
    add -toWrite "generator-settings="
    add -toWrite "force-gamemode=false"
    add -toWrite "allow-nether=true"
    add -toWrite "enforce-whitelist=false"
    $gamemode = Read-Host "gamemode (choice of: 0-3)"
    $gmtest = 0, 1, 2, 3
    if (!$gmtest -ccontains $gamemode) {
    Write-Host -Object "you didn't entered an number in range from 0-3"
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
    $rconPass = Read-Host -Prompt "type your secret Remote Control password here"
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
function eula-txt_questions {
    $eulaAsk = Read-Host -Prompt "do you already have an eula.txt?(y/n)"
    if ($eulaAsk -eq "y") {
        Write-Host -Object "skipping eula.txt"
    }elseif ($eulaAsk -eq "n") {
        eula-txt
    }else{
        Write-Host "not answered y/n. script will now stop."
    break
    }
}
function eula-txt {
    Add-Content $env:TEMP\newserver\eula.txt "eula=true"
}
function start-sh_questions {
    $question = Read-Host -Prompt "do you have an start.sh?(y/n)"
    if ($question -eq "n") {
        start-sh
    }elseif ($question -eq "y") {
        Write-Host -Object "start.sh is skipped"
    }else{
        Write-Host -Object "not answered y/n. script will now stop"
    }
}
function start-sh {
    Add-Content C:\Users\Thomas\AppData\Local\Temp\newserver\start.sh -Value '#!bin/sh'
    Add-Content C:\Users\Thomas\AppData\Local\Temp\newserver\start.sh -Value 'BINDIR="$(dirname "$(readlink -fn "$0")")"'
    Add-Content C:\Users\Thomas\AppData\Local\Temp\newserver\start.sh -Value 'cd "$bindir"'
}
function sftp-1+ssh-1 {
    function comd {
        param ([int]$ID, [string]$comd)
        $1 = Invoke-SSHCommand -SessionId $ID -Command $comd 
    }
    $computername =  Read-Host "what is your computer name/ip adress? This need to be an linux host."
    $usernameTOcomp = Read-Host "what is your username for ${computername}?"
    $1 = New-SFTPSession -Port 22 -ComputerName $computername -Credential $usernameTOcomp 
    $1 = New-SSHSession -Port 22 -ComputerName $computername -Credential $usernameTOcomp
    $1 = comd 0 "cd ~"
    $lsoutput = comd 0 "ls"
    if (!$lsoutput.Output -ccontains $global:serverPRT) {
        Write-Host -Object "your server port already exist. Program will now quit."
        break
    }
    $1 = comd 0 "mkdir $global:serverPRT"
    $1 = Set-SFTPFile -SessionId 0 -RemotePath ./$global:serverPRT -LocalFile $env:TEMP\newserver\eula.txt -Overwrite
    $1 = Set-SFTPFile -SessionId 0 -RemotePath ./$global:serverPRt -LocalFile $env:TEMP\newserver\server.properties -Overwrite
    $1 = Get-SFTPFile -SessionId 0 -RemoteFile ./start_def.sh -LocalPath $env:TEMP\newserver\ -Overwrite
}
function download_questions {
    $downld = Read-Host -Prompt "do you need to download your server.jar?(y/n)"
    if ($downld -eq "y") {
        download
    }elseif ($downld -eq "n") {
        Write-Host -Object "server.jar download skipped"
    }else{
        Write-Host -Object "not answered y/n. Program will now stop"
    }
}
function download {
    function comd {
        param ([int]$ID, [string]$comd)
        $1 = Invoke-SSHCommand -SessionId $ID -Command $comd 
    }
    $jarfile = Read-Host -Prompt "spigot or bukkit (there is basically no difference)"
    if ($jarfile -eq "spigot") {
        $1 = comd 0 "wget -q https://cdn.getbukkit.org/spigot/spigot-1.15.2.jar -O ./$global:serverPRT/spigot-1.15.2.jar"
        Add-Content $env:TEMP\newserver\start.sh "java -Xmx1024M -Xms1024M -jar spigot-1.15.2.jar"
    }elseif ($jarfile -eq "bukkit") {
        $1 = comd 0 "wget -q https://cdn.getbukkit.org/craftbukkit/craftbukkit-1.15.2.jar -O ./$global:serverPRT/craftbukkit-1.15.2.jar"
        Add-Content $env:TEMP\newserver\start.sh "java -Xmx1024M -Xms1024M -jar craftbukkit-1.15.2.jar"
    }elseif ($jarfile -eq "forge") {
        $1 = comd -ID 0 -comd "apt-get install unzip"
        $1 = comd -ID 0 -comd "wget -q https://sourceforge.net/projects/lol1/files/download/latest"
        $1 = comd -ID 0 -comd "unzip forge-1.15.2-31.1.18.zip -d ./$global:serverPRT"
        $1 = comd -ID 0 -comd "rm forge-1.15.2-31.1.18.zip"
    }else{
        Write-Host -Object "not valid value entered, program will now quit."
        break
    }
}
function sftp-2 {
    $1 = Set-SFTPFile -SessionId 0 -RemotePath ./$global:serverPRT/ -LocalFile $env:TEMP\newserver\start.sh
}
function clean-up {
    $1 = Remove-SFTPSession -SessionId 0
    $1 = Remove-SFTPSession -SessionId 1 
    $1 = Remove-Item -Path $env:TEMP\newserver\*.*
    $1 = Remove-SSHSession -SessionId 0
    $1 = rmdir -Path $env:TEMP\newserver
}
function call {
    modules
    make-folder
    server-properties_questions
    eula-txt_questions
    start-sh_questions
    sftp-1+ssh-1
    download_questions
    sftp-2
    clean-up
}
call
#todo list:
#1 repair forge server
#2 comments!