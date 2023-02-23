                        *= $1000
               PRTCHR   = $FFD2

                        ;LOAD TMP ON RESTORE
1000 A9 00              LDA #<32768
1002 8D 18 03           STA $0318
1005 A9 80              LDA #>32768
1007 8D 19 03           STA $0319

                        ;SET COLORS
100A A9 0C              LDA #12
100C 8D 20 D0           STA $D020
100F 8D 21 D0           STA $D021

                        ;CLEAR SCREEN
1012 20 44 E5           JSR $E544

                        ;INIT REVERSE BIT
1015 A9 92              LDA #146
1017 8D 8E 10           STA REVCTL

                        ;SET CHARSET TO UPPERCASE
101A A9 8E              LDA #142
101C 20 D2 FF           JSR PRTCHR

                        ;INIT RNG USING SID CHIP
101F A9 FF              LDA #$FF
1021 8D 0E D4           STA $D40E
1024 8D 0F D4           STA $D40F
1027 A9 80              LDA #$80
1029 8D 12 D4           STA $D412

102C A0 00              LDY #0
102E C0 28     LOOP     CPY #40
1030 D0 16              BNE STREV
1032 A0 00              LDY #0
1034 AE 8E 10           LDX REVCTL
1037 E0 92              CPX #146
1039 D0 08              BNE REVOFF1
103B A9 12              LDA #18
103D 8D 8E 10           STA REVCTL
1040 4C 48 10           JMP STREV
1043 A9 92     REVOFF1  LDA #146
1045 8D 8E 10           STA REVCTL

               STREV
1048 AE 8E 10           LDX REVCTL
104B E0 92              CPX #146
104D D0 08              BNE REVOFF2
104F A9 12              LDA #18
1051 8D 8E 10           STA REVCTL
1054 4C 5C 10           JMP CONT
               REVOFF2
1057 A9 92              LDA #146
1059 8D 8E 10           STA REVCTL
               CONT
105C AD 8E 10           LDA REVCTL
105F 20 D2 FF           JSR PRTCHR

1062 20 84 10           JSR RAND
1065 8D 8F 10           STA RNDZ

                        ;SET COLOR
1068 0A                 ASL A
1069 0A                 ASL A
106A 69 97              ADC #151
106C 20 D2 FF           JSR PRTCHR

                        ;PRINT CHARACTER
106F AE 8F 10           LDX RNDZ
1072 E0 00              CPX #0
1074 D0 05              BNE RIGHT
1076 A9 A9     LEFT     LDA #169
1078 4C 7D 10           JMP PRINT
107B A9 DF     RIGHT    LDA #223
107D 20 D2 FF  PRINT    JSR PRTCHR

1080 C8                 INY
1081 4C 2E 10           JMP LOOP

                        ;GET RANDOM NUMBER
1084 AD 1B D4  RAND     LDA $D41B
1087 C9 02              CMP #$02
1089 B0 F9              BCS RAND
108B 69 00              ADC #$00
108D 60                 RTS

108E 00        REVCTL   .BYTE 0
108F 00        RNDZ     .BYTE 0
