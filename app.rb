require 'openssl'
require 'base64'

class FPEAlgorithm
  def initialize()
    @cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    @cipher.random_iv
  end

  def encrypt(serial, key)
    @cipher.encrypt
    @cipher.key = key
    encrypted = @cipher.update(serial.to_s) + @cipher.final
    Base64.strict_encode64(encrypted)  # Use strict_encode64 to avoid padding issues
  end

  def decrypt(encrypted, key)
    @cipher.decrypt
    @cipher.key = key
    decoded_encrypted = Base64.strict_decode64(encrypted)  # Decode with strict_decode64
    decrypted = @cipher.update(decoded_encrypted) + @cipher.final
    decrypted.to_i
  end

  private

  def luhn(input)
    10 - input.to_s.split(//).collect(&:to_i).zip((1..input.to_s.length).to_a).map { |v, i| i % 2 == 0 ? (v * 2 < 10 ? v * 2 : v * 2 - 9) : v }.inject(&:+) % 10
  end
end

encryption_key = 'fdkjgfdoi4tu45fkgkljfg9485439tkjfgnjdshfghwhe54350gfgklkgje34324nkjdfhk458458435'
decryption_key = 'fdkjgfdoi4tu45fkgkljfg9485439tkjfgnjdshfghwhe54350gfgklkgje34324nkjdfhk458458435'

fpe = FPEAlgorithm.new()

puts "Enter a serial number to encrypt:"
serial_input = gets.chomp.to_i

order_number = fpe.encrypt(serial_input, encryption_key)

decrypted_order_number = fpe.decrypt(order_number, decryption_key)

puts "Encrypted order number: #{order_number}"
puts "Decrypted order number (original serial): #{decrypted_order_number}"
