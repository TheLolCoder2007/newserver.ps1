﻿Write-Host -Object "" #made by YOURNAMEHERE
$loading = "" #loading functions & modules, wait a moment...
$serverpropertiesquestion = ""#server.properties:simple or advanced? Or choose 'none' if you don't want an server.properties file
$serverpropertiessimple = ""#simple
$serverpropertiesadvanced = ""#advanced
$serverpropertiesnone = ""#none
$serverPRTquestion = "" #what is your server port you want to use? This is used later in the script.
$serverPRTskip = "" #server.properties is skipped
$serverprtfault = ""#you didn't enter simple, advanced or none!
$fillin = ""#fill the thing in, what you want to get written to server.properties. If you don't know what those values must be, press enter.
$sameAsServerPRT = ""#the same as server port
$qportquestion = ""#what is your query port? (it will be the same as the server port). Fill in a number (25565 recommended)
$gamemodequestion = ""#which gamemode do you want? (0=survivor, 1=creative, 2=adventure, 3=spectator)
$gamemodefault = ""#you didn't entered an number in range from 0-3. The script will now quit
$rconpassquestion = ""#type your secret Remote Control password here
$eula_txtquestion = ""#do you already have an eula.txt?(y/n)(default=n)
$y = ""#y
$n = ""#n
$eula_txtskip = ""#skipping eula.txt
$eula_txtfault = ""#not answered y/n. script will now quit.
$start_shquestion = ""#do you have an start.sh?(y/n)(default=n)
$start_shskip = ""#start.sh is skipped
$start_shfault = $eula_txtfault
$compnamequestion = ""#What is your computer name/ip adress for the server where you want to host the server on? This need to be an linux host.
$usernamequestion = ""#what is your username for
$passwordTwice = ""#You need to fill in your password twice
$serverprtexists = ""#your server port already exist. Program will now quit.
$downloadquestion = ""#do you have a server.jar?(y/n)(default=n)
$serverjarskipped = ""#server.jar download skipped
$serverjarfault = $eula_txtfault
$jarfilechoose = ""#spigot, bukkit or forge (bukkit recommended)
$notvalidvalue = ""#not valid value entered, program will now quit.
