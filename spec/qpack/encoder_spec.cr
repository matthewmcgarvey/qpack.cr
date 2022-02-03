require "../spec_helper"

describe QPack::Encoder do
  it "compresses pseudoheaders" do
    headers = HTTP::Headers{":method" => "GET", ":scheme" => "https", ":path" => "/"}
    encoder = QPack::Encoder.new
    io = IO::Memory.new

    encoder.write(headers, io)

    expected = Bytes[
      0x00_u8,           # Required Insert Count
      0x00_u8,           # Delta Base
      (0xc0 | 17).to_u8, # Indexed Header Field, static table, index 17
      (0xc0 | 23).to_u8, # Indexed Header Field, static table, index 23
      (0xc0 | 1).to_u8,  # Indexed Header Field, static table, index 1
    ]
    io.to_slice.should eq(expected)
  end

  it "compresses index name with literal value" do
    headers = HTTP::Headers{":method" => "TRACE"}
    encoder = QPack::Encoder.new
    io = IO::Memory.new

    encoder.write(headers, io)

    expected = Bytes[
      0x00_u8, # Required Insert Count
      0x00_u8, # Delta Base
      0x5f_u8, # 0101 1111  (first index of ":method" is 15)
      0x00_u8,
      0x05_u8, # value length, no huffman
      0x54_u8, # T
      0x52_u8, # R
      0x41_u8, # A
      0x43_u8, # C
      0x45_u8, # E
    ]
    io.to_slice.should eq(expected)
  end

  it "compresses literal" do
    headers = HTTP::Headers{"X-Custom-Header" => "anyvalue"}
    encoder = QPack::Encoder.new
    io = IO::Memory.new

    encoder.write(headers, io)

    expected = Bytes[
      0x00_u8,                                                                                                                               # Required Insert Count
      0x00_u8,                                                                                                                               # Delta Base
      0x27_u8,                                                                                                                               # 0010 0111
      0x08_u8,                                                                                                                               # Length = 15, 15 - 7 = 8
      0x58_u8, 0x2d_u8, 0x43_u8, 0x75_u8, 0x73_u8, 0x74_u8, 0x6f_u8, 0x6d_u8, 0x2d_u8, 0x48_u8, 0x65_u8, 0x61_u8, 0x64_u8, 0x65_u8, 0x72_u8, # X-Custom-Header
      0x08_u8,                                                                                                                               # Length = 8
      0x61_u8, 0x6e_u8, 0x79_u8, 0x76_u8, 0x61_u8, 0x6c_u8, 0x75_u8, 0x65_u8,                                                                # anyvalue
    ]
    io.to_slice.should eq(expected)
  end
end
