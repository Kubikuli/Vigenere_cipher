# Vigenere Cipher - MIPS64 Assembly
**VUT FIT 2024/25 - INP Project 2**

Implementation of the Vigenere cipher algorithm in MIPS64 assembly language.

## Overview
This project implements a modified Vigenere cipher that ciphers given text with given key, alternating between adding and subtracting the key. The cipher uses a repeating key and processes only lowercase letters (a-z).

## Algorithm Logic
1. For even positions (0, 2, 4...): Add key character value
2. For odd positions (1, 3, 5...): Subtract key character value
3. Key characters are converted to 1-based values (a=1, b=2, c=3...)
4. Result wraps around alphabet boundaries using modulo arithmetic

## Academic Context
This project demonstrates understanding of:
- MIPS64 assembly programming
- Memory operations and addressing
- Control flow and branching
- Character manipulation and ASCII operations
- Algorithm implementation in low-level language

Total points: 10/10
