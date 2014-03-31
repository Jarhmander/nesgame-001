cl65 -t nes --asm-include-dir include src/nes-header.s src/core.s src/mapper69.s src/controller.s foo.s -Clinker/mapper69.ld -m out.map -o out.nes
