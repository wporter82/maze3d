         *= $1000
prtchr   = $ffd2
 
         ;load tmp on restore
         lda #<32768
         sta $0318
         lda #>32768
         sta $0319
 
         ;set colors
         lda #12
         sta $d020
         sta $d021
 
         ;clear screen
         jsr $e544
 
         ;init reverse bit
         lda #146
         sta revctl
 
         ;set charset to uppercase
         lda #142
         jsr prtchr
 
         ;init rng using sid chip
         lda #$ff
         sta $d40e
         sta $d40f
         lda #$80
         sta $d412
 
         ldy #0
loop     cpy #40
         bne strev
         ldy #0
         ldx revctl
         cpx #146
         bne revoff1
         lda #18
         sta revctl
         jmp strev
revoff1  lda #146
         sta revctl
 
strev
         ldx revctl
         cpx #146
         bne revoff2
         lda #18
         sta revctl
         jmp cont
revoff2
         lda #146
         sta revctl
cont
         lda revctl
         jsr prtchr
 
         jsr rand
         sta rndz
 
         ;set color
         asl a
         asl a
         adc #151
         jsr prtchr
 
         ;print character
         ldx rndz
         cpx #0
         bne right
left     lda #169
         jmp print
right    lda #223
print    jsr prtchr
 
         iny
         jmp loop
 
         ;get random number 0 or 1
rand     lda $d41b
         and #1
         rts
 
revctl   .byte 0
rndz     .byte 0
