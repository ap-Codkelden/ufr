@echo Start @ %date% %time%

@ java -jar d:\saxon\saxon9pe.jar -a -config:d:\saxon\config.xml %1 -o:%2

@echo End @%date% %time%
@ pause