#!/usr/bin/env python3

import hashlib
import base64
import hmac
import os
from Crypto.Cipher import DES
from Crypto.Util.number import long_to_bytes, bytes_to_long

def md5_hash(data):
    return hashlib.md5(data.encode()).hexdigest()

def sha256_hash(data):
    return hashlib.sha256(data.encode()).hexdigest()

def base64_encode(data):
    return base64.b64encode(data.encode()).decode()

def set_parity(data):
    """Set the correct parity bit for each 7-bit chunk to get an 8-byte DES key."""
    result = bytearray()
    temp = bytes_to_long(data)
    
    # Split the data into 7-bit chunks
    for _ in range(8):
        # Extract 7 bits from the data
        chunk = temp & 0b1111111
        temp >>= 7
        
        # Calculate parity
        parity = 1
        for b in bin(chunk)[2:].zfill(7):
            parity ^= int(b)
        
        # Combine 7-bit chunk with parity bit to form 8-bit byte
        result.insert(0, (chunk << 1) | parity)
    
    return bytes(result)

def lm_hash(password):
    # Ensure password is no more than 14 characters long and uppercased
    password = password.upper().ljust(14, '\0')[:14]

    # Split password into two 7-byte halves
    half1 = password[:7]
    half2 = password[7:]

    # Set correct parity
    key1 = set_parity(half1.encode('latin1'))
    key2 = set_parity(half2.encode('latin1'))

    # Encrypt the string "KGS!@#$%" using each key
    magic_string = b"KGS!@#$%"
    cipher1 = DES.new(key1, DES.MODE_ECB)
    cipher2 = DES.new(key2, DES.MODE_ECB)

    hash1 = cipher1.encrypt(magic_string)
    hash2 = cipher2.encrypt(magic_string)

    # Concatenate the two results
    lm_hashed_password = hash1 + hash2
    return lm_hashed_password.hex().upper()

def ntlm_hash(password):
    return hashlib.new('md4', password.encode('utf-16le')).hexdigest()

if __name__ == '__main__':
    hash_functions = [
        ("base64", base64_encode),
        ("md5", md5_hash),
        ("sha256", sha256_hash),
        ("lm", lm_hash),
        ("ntlm", ntlm_hash)
    ]
    hash_options = "\n".join([f"{idx + 1}. {name}" for idx, (name, func) in enumerate(hash_functions)])

    print("Available hash types:")
    print(hash_options)

    choices_input = input("Choose a hash type (e.g., 1,2,3 or all): ")

    # Check if user input is "all"
    if choices_input.lower() == "all":
        choices = [str(i+1) for i in range(len(hash_functions))]
    else:
        choices = choices_input.split(',')

    input_string = input("Enter the string you want to hash: ")

    for choice in choices:
        try:
            idx = int(choice) - 1
            name, func = hash_functions[idx]
            print(f"{name.upper()} Hash: {func(input_string)}")
        except Exception as e:
            print(f"Invalid choice: {choice}. Error: {e}")
