require "./spec_helper"

describe Axi do
  # it "works" do
  #  false.should eq(true)
  # end

  it "can create basic streams" do
    Axi::Stream(Int32, Int32).new
    Axi::Stream(Int32, Int64).new
  end

  it "can relay values" do
    s = Axi::Stream(Int32, Int32).new
    s.send(2).should eq(2)
  end

  it "can process values" do
    s = Axi::Stream(Int32, String).new
    s.transform ->(i : Int32) { i.to_s }
    s.send(2).should eq("2")
  end

  it "can link to streams and other channels" do
    s1 = Axi::Stream(Int32, Int32).new
    s1.transform ->(i : Int32) { i ** i }

    s2 = Axi::Stream(Int32, String).new
    s2.transform ->(i : Int32) { i.to_s }
    s1.link(s2)

    c = Channel(String).new(2)
    s2.link(c)

    s1.send(5)
    c.receive.should eq("3125")
  end

  it "can send values asynchronously" do
    s = Axi::Stream(Int32, Int32).new
    s.transform ->(i : Int32) { i ** i }

    c = Channel(Int32).new(1)
    s.link(c)

    s.send(5, true)
    c.receive.should eq(3125)
  end
end
