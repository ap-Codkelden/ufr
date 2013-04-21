@echo Start @ %date% %time%

@REM java -jar d:\saxon\saxon9pe.jar -a -config:d:\saxon\config.xml %1 -o:%2

java -jar d:\saxon\saxon9pe.jar -config:d:\saxon\config.xml -xsl:%1 %2 -o:%3 

@echo End @%date% %time%
@ pause