module QPack
  class Encoder
    @static_table : StaticTable
    @dynamic_table : DynamicTable

    def initialize(
      @static_table = StaticTable.new,
      @dynamic_table = DynamicTable.new
    )
    end

    def write(headers : HTTP::Headers, io : IO)
      add_header_block_prefix(io)

      headers.each { |name, values| write(name, values, io) }
    end

    private def write(name : String, values : Array(String), io : IO)
      values.each do |value|
        if idx = @static_table.find_index(name, value)
          if @static_table.value_at(idx) == value
            write_indexed_header_field(idx, io)
          else
            write_literal_header_field_with_name_reference(idx, value, io)
          end
        else
          write_literal_header_field_without_name_reference(name, value, io)
        end
      end
    end

    # https://datatracker.ietf.org/doc/html/draft-ietf-quic-qpack-21#section-4.5.2
    private def write_indexed_header_field(idx : Int32, io : IO)
      insert_prefixed_integer(6, 0xc0_u8, idx, io)
    end

    # https://datatracker.ietf.org/doc/html/draft-ietf-quic-qpack-21#section-4.5.4
    private def write_literal_header_field_with_name_reference(idx : Int32, value : String, io : IO)
      insert_prefixed_integer(4, 0x50_u8, idx, io)
      insert_prefixed_integer(7, 0x00_u8, value.bytesize, io)
      io << value
    end

    # https://datatracker.ietf.org/doc/html/draft-ietf-quic-qpack-21#section-4.5.6
    private def write_literal_header_field_without_name_reference(name : String, value : String, io : IO)
      insert_prefixed_integer(3, 0x20_u8, name.bytesize, io)
      io << name
      insert_prefixed_integer(7, 0x00_u8, value.bytesize, io)
      io << value
    end

    # https://datatracker.ietf.org/doc/html/draft-ietf-quic-qpack-21#section-4.5.1
    private def add_header_block_prefix(io : IO)
      io.write_byte(0x00_u8)
      io.write_byte(0x00_u8)
    end

    private def insert_prefixed_integer(length : Int32, prefix : UInt8, value : Int32, io : IO)
      max_prefix = ((2 ** length) - 1).to_u8
      if value < max_prefix
        io.write_byte(value.to_u8 | prefix)
      else
        io.write_byte(max_prefix | prefix)
        value -= max_prefix
        while value >= 128
          io.write_byte(((value % 128) + 128).to_u8)
          value /= 128
        end
        io.write_byte(value.to_u8)
      end
    end
  end
end
