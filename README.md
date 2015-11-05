Archivator
===============================
A simple script to archive files using 7z
This script is based on a script written by Paul Cunningham: http://exchangeserverpro.com/powershell-script-iis-logs-cleanup

Table of Contents
=================

  1. Install 7Zip on your machine
  2. Prepare Archivator script
  3. Examples
  4. Licensing
  5. Contacts
  6. To do
  
  1. Install 7Zip on your machine
===============

* Download 7Zip from this the official link: http://www.7-zip.org/
* Install it to your C:\Program Files\7-Zip\

  2. Prepare Archivator script
===============

* If you have chosen another directory for your 7zip installation, you need to update the script file.

* Go to line 60: set-alias sevenzip "C:\Program Files\7-Zip\7z.exe" and update it to the your chosen directory.

* Open Windows Powershell and update the execution policy using this command: set-executionpolicy bypass

* Confirm change by typing yes

  3. Examples
===============

* .\Archivator -FilesPath "D:\Extracts\" -FileExtension "*.txt" -DaysToKeep 3 -ArchivePath "D:\Extracts\Archive" 

This command will zip all txt files in D:\Extracts older than from J-3 and move them to D:\Extracts\Archive\dd-MM-YY

* .\Archivator -FilesPath "D:\Extracts\" -FileExtension "*.log" -DaysToKeep 0" 

This command will zip all log files in D:\Extracts older than from J and put them inside a folder named dd-MM-YY => D:\Extracts\dd-MM-YY

   4. Licensing
===============

Archivator is licensed under a Creative Commons Attribution 3.0 Unported License.

![ScreenShot](http://i.imgur.com/4XWrp.png)

To view a copy of this license, visit [ http://creativecommons.org/licenses/by/3.0/deed.en_US ].

   5. Contacts
===============

Bilel Msekni (msekni.bilel@gmail.com)

LinkedIn: https://fr.linkedin.com/in/bilelmsekni

   6. To do
===============

...
