require 'openssl'
require 'base64'
require 'yaml'
require 'digest'

class FPEAlgorithm
  def initialize()
    @cipher = OpenSSL::Cipher::RC4.new()
    @cipher.random_iv
  end

  def encrypt(data, key)
    @cipher.encrypt
    @cipher.key = key
    padded_data = data.to_s.ljust(data.to_s.length, "\x00")
    encrypted = @cipher.update(padded_data.to_s) + @cipher.final
    encoded = Base64.strict_encode64(encrypted)
    packed_data = encoded.unpack("C*")
    result = encoded.to_s.unpack("H*")[0].to_i(16)
  end

  def decrypt(encrypted_data, key)
    @cipher.decrypt
    @cipher.key = key
    decoded_data = Base64.strict_decode64([encrypted_data.to_s(16)].pack('H*'))
    decrypted = @cipher.update(decoded_data.to_s) + @cipher.final
    decrypted.gsub!("\x00", "")
    decrypted.to_i
  end
end

config = YAML.load_file('config.yml')
encryption_key = config['encryption_key']
decryption_key = config['decryption_key']

fpe = FPEAlgorithm.new()

puts "Enter a serial number to encrypt:"
serial_input = gets.chomp.to_i

order_number = fpe.encrypt(serial_input, encryption_key)

decrypted_order_number = fpe.decrypt(order_number, decryption_key)

puts "Encrypted order number: #{order_number}"
puts "Decrypted order number (original serial): #{decrypted_order_number}"
