#Download official compressed file exe
#FUji Xerox
Invoke-WebRequest -Uri "https://support-fb.fujifilm.com/tiles/common/hc_drivers_download.jsp?system=%27Windows%2010%2064bit%27&shortdesc=null&xcrealpath=OJ7/3Y0JABD2FrJ4m7x3OhhSUpny3LIjCz80yWGJWd6AciVZT/oSemkJS5E7YNzuE9duqPlFzbguGSJgl1hdqWyQtFofCU2ANSXj89U92V/DIY/rad9EOA==" -OutFile "C:\temp\fxprinter.exe"

#Konica C364SeriesPCL
#Invoke-WebRequest -Uri "https://dl.konicaminolta.eu/en?tx_kmanacondaimport_downloadproxy[fileId]=4bdfc9dbead1ee58262a0b364faf59a6&tx_kmanacondaimport_downloadproxy[documentId]=129831&#tx_kmanacondaimport_downloadproxy[system]=KonicaMinolta&tx_kmanacondaimport_downloadproxy[language]=EN&type=1558521685" -OutFile "C:\temp\konicaM.zip"

New-Item -Path 'c:\temp\fxdriver' -ItemType Directory

#Need to edit and replace it with your zip/rar
#$WinRar = "C:\Program Files\WinRAR\WinRar.exe"
$7Zip = "C:\Program Files\7-Zip\7z.exe"
$Exe = Get-ChildItem -Path "C:\temp\fxprinter.exe"
#&$Winrar x -y $Exe.FullName "C:\temp\fxdriver" -Wait
#x is to extract according to folder when zip | e is to extract everything into one folder
&$7Zip x -y $Exe.FullName -o"c:\temp\fxdriver" *.* -r -Wait

pnputil.exe -i -a "C:\temp\fxdriver\Software\PCL\amd64\English\001\FX6BEAL.inf"

#Start-Process "C:\temp\fxprinter.exe" -Argumentlist "/a" -Wait

#windows default folder when it extract
#pnputil.exe -i -a "C:\Windows\SysWOW64\fxap6c7771pcl6180910wvt6ien\Software\PCL\amd64\English\001\FX6BEAL.inf"

#Download if you are using inf zip file
#Expand-Archive -Path 001.zip "c:\temp\"
#pnputil.exe -i -a "C:\temp\001\FX6BEAL.inf"


$PrinterName="FX ApeosPort-VI C4471"
$PortNumber="0.0.0.0"
$PortName="0.0.0.0"
$PrintDriverName="FX ApeosPort-VI C4471 PCL 6"

$PortExists = Get-Printerport -Name $PortName -ErrorAction SilentlyContinue
if (-not $PortExists) {
  Add-PrinterPort -name $PortName -PrinterHostAddress $PortNumber
}
$PrintDriverExists = Get-PrinterDriver -name $PrintDriverName -ErrorAction SilentlyContinue
if ($PrintDriverExists) {
    Add-Printer -Name $PrintDriverName -PortName $PortName -DriverName $PrintDriverName
    Rename-Printer -Name $PrintDriverName -NewName $PrinterName
}
else{
    Add-PrinterDriver -Name $PrintDriverName
    Add-Printer -Name $PrintDriverName -PortName $PortName -DriverName $PrintDriverName
    Rename-Printer -Name $PrintDriverName -NewName $PrinterName
}

Set-PrintConfiguration -PrinterName "FX ApeosPort-VI C4471" -PaperSize A4 -Color $False
