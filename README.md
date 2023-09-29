# Format Preserving Algorithm in Ruby

Format preserving encryption (FPE) is a method of encryption where the resulting cipher text has the same form as the input clear text. The form of the text can vary according to use and the application. One example is a 16 digit credit card number. After using FPE to encrypt a credit card number, the resulting cipher text is another 16 digit number. In this example of the credit card number, the output cipher text is limited to numeric digits only.

The CSNBFPEE, CSNBFPED, CSNBFPET, and CSNBPTRE callable services implement the VISA Format Preserving Encryption algorithm, which is a counter mode stream cipher.

The CSNBFFXD, CSNBFFXE, and CSNBFFXT callable services implement the NIST FFX algorithms. The FF1, FF2, and FF2.1 algorithms are all built in a similar way, using AES as the base cipher for the operations. The overall algorithm uses a Pseudorandom Function (PRF) as its main encryption function using a variable length Feistal network. Each of the three algorithms contain a different PRF to achieve the result. Each algorithm also takes in a tweak string to further vary the action of the PRF. FF1 uses either a 128-bit AES key or a 256-bit AES key. FF2 and FF2.1 only support AES 128-bit keys.

On Decryption, you might not get the same value as the serial number before encryption.
