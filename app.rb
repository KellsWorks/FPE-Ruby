require 'openssl'

class FPEAlgorithm
  def initialize(key)
    @cipher = OpenSSL::Cipher::Cipher.new('rc4-40')
    @cipher.key = key
  end

  def encrypt(serial)
    @cipher.encrypt

    padded_serial = "%015d" % serial
    padded_serial_array = [padded_serial.slice(0, 10).to_i, padded_serial.slice(10, 15).to_i]
    padded_serial_packed = padded_serial_array.pack('LS')

    padded_serial_packed_encrypted = @cipher.update(padded_serial_packed) + @cipher.final

    order_number_pre = padded_serial_packed_encrypted.unpack('LS')

    order_number_pre_padded = ["%010d" % order_number_pre[0], "%05d" % order_number_pre[1]]

    order_number = [
      luhn(order_number_pre_padded[0].to_i) + order_number_pre_padded[0].to_i,
      luhn(order_number_pre_padded[1].to_i) + order_number_pre_padded[1].to_i
    ]

    order_number
  end

  def decrypt(order_number, key)
    d = OpenSSL::Cipher::Cipher.new('rc4-40')
    d.decrypt
    d.key = key

    order_number_pre_checksum = [
      order_number[0].to_s.slice(1, 11).to_i,
      order_number[1].to_s.slice(1, 5).to_i
    ]

    order_number_pre_checksum_packed = order_number_pre_checksum.pack('LS')
    padded_serial_packed_decrypted = d.update(order_number_pre_checksum_packed) + d.final
    padded_serial_packed_decrypted_unpacked = padded_serial_packed_decrypted.unpack('LS')
    padded_serial_packed_decrypted_unpacked_reformatted = [
      "%010d" % padded_serial_packed_decrypted_unpacked[0],
      "%05d" % padded_serial_packed_decrypted_unpacked[1]
    ]
    padded_serial_packed_decrypted_unpacked_reformatted
  end

  private

  def luhn(input)
    10 - input.to_s.split(//).collect(&:to_i).zip((1..input.to_s.length).to_a).map { |v, i| i % 2 == 0 ? (v * 2 < 10 ? v * 2 : v * 2 - 9) : v }.inject(&:+) % 10
  end
end

encryption_key = 'fdkjgfdoi4tu45fkgkljfg9485439tkjfgnjdshfghwhe54350gfgklkgje34324nkjdfhk458458435'
decryption_key = 'fdkjgfdoi4tu45fkgkljfg9485439tkjfgnjdshfghwhe54350gfgklkgje34324nkjdfhk458458435'

fpe = FPEAlgorithm.new(encryption_key)

puts "Enter a serial number to encrypt:"
serial_input = gets.chomp.to_i

order_number = fpe.encrypt(serial_input)

decrypted_order_number = fpe.decrypt(order_number, decryption_key)

puts "Encrypted order number: #{order_number}"
puts "Decrypted order number (original serial): #{decrypted_order_number}"
