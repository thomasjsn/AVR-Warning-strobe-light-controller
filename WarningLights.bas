'--------------------------------------------------------------
'                   Thomas Jensen | stdout.no
'--------------------------------------------------------------
'  file: AVR_WARNING_LIGHTS v1.0
'  date: 21/03/2008
'--------------------------------------------------------------
$regfile = "attiny2313.dat"
$crystal = 8000000
Config Portd = Input
Config Portb = Output
Config Watchdog = 1024

Dim Program As Byte , A As Byte , B As Byte , C As Byte , Mode_select As Byte , Random As Byte
Dim Random_counter As Integer , Eeprom As Eram Byte
Config Timer1 = Pwm , Pwm = 8 , Prescale = 1 , Compare A Pwm = Clear Up , Compare B Pwm = Clear Up

'Out
'PB.3 : LEDs 1
'PB.4 : LEDs 2

'In
'PD.0 : Cycle trough modes
'PD.1 : Change mode

Ddrb.3 = 1
Ddrb.4 = 1
Pwm1a = 255
Pwm1b = 255

'get program from eeprom
If Eeprom < 1 Or Eeprom > 5 Then Eeprom = 1
Program = Eeprom

Start Watchdog

Main:
Select Case Program

'1: fade quick - no pause
Case 1
For A = 1 To 25
   Pwm1a = Pwm1a - 10
   Gosub Switches
   Waitms 10
Next A
   Waitms 10
   Gosub Switches
   Waitms 10
   Gosub Switches
For A = 1 To 25
   Pwm1a = Pwm1a + 10
   Gosub Switches
   Waitms 10
Next A

For A = 1 To 25
   Pwm1b = Pwm1b - 10
   Gosub Switches
   Waitms 10
Next A
   Waitms 10
   Gosub Switches
   Waitms 10
   Gosub Switches
For A = 1 To 25
   Pwm1b = Pwm1b + 10
   Gosub Switches
   Waitms 10
Next A

'2: pulse x 3 - pause 300ms
Case 2
For A = 1 To 3
   Pwm1a = 0
   For C = 1 To 3
   Waitms 10
   Gosub Switches
   Next C
   Pwm1a = 255
   For C = 1 To 5
   Waitms 10
   Gosub Switches
   Next C
Next A
   For C = 1 To 30
   Waitms 10
   Gosub Switches
   Next C

For A = 1 To 3
   Pwm1b = 0
   For C = 1 To 3
   Waitms 10
   Gosub Switches
   Next C
   Pwm1b = 255
   For C = 1 To 5
   Waitms 10
   Gosub Switches
   Next C
Next A
   For C = 1 To 30
   Waitms 10
   Gosub Switches
   Next C

'3: long pulse singel - long delay
Case 3
   Pwm1a = 0
   For C = 1 To 5
   Waitms 10
   Gosub Switches
   Next C
   Pwm1a = 255
   For C = 1 To 10
   Waitms 10
   Gosub Switches
   Next C

   Pwm1b = 0
   For C = 1 To 5
   Waitms 10
   Gosub Switches
   Next C
   Pwm1b = 255
   For C = 1 To 30
   Waitms 10
   Gosub Switches
   Next C

'4: pulse singel - pause random ms
Case 4
   Pwm1a = 0
   For C = 1 To 3
   Waitms 10
   Gosub Switches
   Next C
   Pwm1a = 255
   Random = Rnd(20)
   For C = 1 To Random
   Waitms 10
   Gosub Switches
   Next C

   Pwm1b = 0
   For C = 1 To 3
   Waitms 10
   Gosub Switches
   Next C
   Pwm1b = 255
   Random = Rnd(20)
   For C = 1 To Random
   Waitms 10
   Gosub Switches
   Next C

'5: strobe
Case 5
   Pwm1a = 0
   For C = 1 To 3
   Waitms 10
   Gosub Switches
   Next C
   Pwm1a = 255
   For C = 1 To 8
   Waitms 10
   Gosub Switches
   Next C

   Pwm1b = 0
   For C = 1 To 3
   Waitms 10
   Gosub Switches
   Next C
   Pwm1b = 255
   For C = 1 To 8
   Waitms 10
   Gosub Switches
   Next C

End Select

Goto Main
End

'switches, mode change and random
Switches:
If Pind.1 = 1 Then Mode_select = 0
If Pind.1 = 0 And Mode_select = 0 Then
   Mode_select = 1
   Program = Program + 1
   Eeprom = Program
End If
If Pind.0 = 0 Then
   Incr Random_counter
   If Random_counter > 600 Then
      Random_counter = 0
      Program = Program + 1
   End If
   Else
   Random_counter = 0
End If

If Program = 6 Then Program = 1
Reset Watchdog

Return
End