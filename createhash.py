import hashlib,binascii
hash = hashlib.new('md4', "yourpasswordhere".encode('utf-16le')).digest()
print binascii.hexlify(hash)
