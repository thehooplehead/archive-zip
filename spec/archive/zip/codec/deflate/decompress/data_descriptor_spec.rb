require File.dirname(__FILE__) + '/../../../../../../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/classes'
require 'archive/zip/codec/deflate'

describe "Archive::Zip::Codec::Deflate::Decompress#data_descriptor" do
  it "is an instance of Archive::Zip::DataDescriptor" do
    DeflateSpecs.compressed_data do |cd|
      closed_decompressor = Archive::Zip::Codec::Deflate::Decompress.open(
        cd
      ) do |decompressor|
        decompressor.read
        decompressor.data_descriptor.class.should ==
          Archive::Zip::DataDescriptor
        decompressor
      end
      closed_decompressor.data_descriptor.class.should ==
        Archive::Zip::DataDescriptor
    end
  end

  it "has a crc32 attribute containing the CRC32 checksum" do
    crc32 = Zlib.crc32(DeflateSpecs.test_data)
    DeflateSpecs.compressed_data do |cd|
      closed_decompressor = Archive::Zip::Codec::Deflate::Decompress.open(
        cd
      ) do |decompressor|
        decompressor.read
        decompressor.data_descriptor.crc32.should == crc32
        decompressor
      end
      closed_decompressor.data_descriptor.crc32.should == crc32
    end
  end

  it "has a compressed_size attribute containing the size of the compressed data" do
    compressed_size = DeflateSpecs.compressed_data.size
    DeflateSpecs.compressed_data do |cd|
      closed_decompressor = Archive::Zip::Codec::Deflate::Decompress.open(
        cd
      ) do |decompressor|
        decompressor.read
        decompressor.data_descriptor.compressed_size.should == compressed_size
        decompressor
      end
      closed_decompressor.data_descriptor.compressed_size.should ==
        compressed_size
    end
  end

  it "has an uncompressed_size attribute containing the size of the input data" do
    uncompressed_size = DeflateSpecs.test_data.size
    DeflateSpecs.compressed_data do |cd|
      closed_decompressor = Archive::Zip::Codec::Deflate::Decompress.open(
        cd
      ) do |decompressor|
        decompressor.read
        decompressor.data_descriptor.uncompressed_size.should ==
          uncompressed_size
        decompressor
      end
      closed_decompressor.data_descriptor.uncompressed_size.should ==
        uncompressed_size
    end
  end
end
