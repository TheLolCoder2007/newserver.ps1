﻿Write-Host -Object "Gemaakt door thelolcoder2007"
$loading = "Functies en modules aan het laden, even geduld alstublieft..."
$serverpropertiesquestion = "Server.properties:simpel of geavanceerd? Of kies 'geen' als je geen server.properties bestand wil."
$serverpropertiessimple = "simpel"
$serverpropertiesadvanced = "geavanceerd"
$serverpropertiesnone = "geen"
$serverPRTquestion = "Wat is de server port die je wil gebruiken? Dit is benodigd voor het latere script."
$serverPRTskip = "server.properties is overgeslagen"
$serverprtfault = "Je hebt niet simpel, geavanceerd of geen ingevuld!"
$fillin = "Vul hetgene in, wat je in het server.properties-bestand geschreven wil hebben. Weet je niet wat je wil, druk dan op enter."
$sameAsServerPRT = "Hetzelfde als de server port"
$qportquestion = "Wat is je query port? (het zal hetzelfde zijn als de server port)"
$gamemodequestion = "Welke spelmodus (gamemode) wil je? (0=survival, 1=creative, 2=adventure, 3=spectator)"
$gamemodefault = "Je hebt geen nummer tussen 0 en 3 ingevuld. Het script zal nu sluiten."
$rconpassquestion = "Typ hier je geheime remote control (controle op afstand) wachtwoord hier"
$eula_txtquestion = "Heb je al een eula.txt bestand? (j/n)"
$y = "j"
$n = "n"
$eula_txtskip = "Eula.txt is overgeslagen"
$eula_txtfault = "Je hebt niet j/n geantwoord. Het script zal nu sluiten."
$start_shquestion = "Heb je al een start.sh? (j/n)"
$start_shskip = "Start.sh is geskipt."
$start_shfault = $eula_txtfault
$compnamequestion = "Wat is de computernaam/het ip-adres van de server waar je de minecraft server op wil laten draaien? Dit moet een Linux computer zijn."
$usernamequestion = "Wat is de gebruikersnaam voor "
$passwordTwice = "Je moet het wachtwoord twee keer invullen."
$serverprtexists = "De server port die bestaat al. Het programma zal nu sluiten."
$downloadquestion = "Moet je nog een server.jar downloaden? (j/n)"
$serverjarskipped = "De download van server.jar is overgeslagen."
$serverjarfault = $eula_txtfault
$jarfilechoose = "Spigot, bukkit or forge? (bukkit is aan te raden)"
$notvalidvalue = "Geen valide antwoord gegeven, het programma zal nu sluiten."