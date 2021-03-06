; Ich nehme an, dass 1 Datenwort 2 Byte sind, weil WORD in Assembler 16 Bit sind.
; Dann hat der Cache 4 Zeilen mit jeweils 2 Blöcken von jeweils 2 Worten.
; Die Adressen sind dann unterteilt in 1 Byte-Bit, 1 Word-Bit, 2 Line-Bits und der Rest ist Tag.

segment .data
  input_format db "%d", 0
  output_format db "Line: %d, Tag: %d", 0Ah, 0
segment .text
  global asm_main
  extern scanf
  extern printf
asm_main:
  enter 0, 0
  pusha

  ; Lege eine lokale Variable mit Wert 0 an
  push DWORD 0

  ; Lese eine Zahl in die lokale Variable
  push esp
  push input_format
  call scanf
  add esp, 8

  ; Isoliere die ersten 28 Bit (TAG) und lege sie auf den Stack als Argument für printf
  mov eax, [esp]
  shr eax, 4
  push eax

  ; Isoliere Bit 3 und 4 (LINE) und lege sie auf den Stack als Argument für printf
  mov eax, [esp + 4]
  and eax, 1100b
  shr eax, 2
  push eax

  ; Ergebnisse ausgeben
  push output_format
  call printf

  ; Stack zurücksetzen
  add esp, 16
  
  popa
  leave
  mov eax, 0
  ret
