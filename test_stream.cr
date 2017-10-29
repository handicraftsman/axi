require "./src/axi"

s = Axi::Stream(Int32, Int64).new
puts s.send(2).inspect
s.transform ->(val : Int32) { val.to_i64 }
s.on_transform ->(ival : Int32, oval : Int64) { "do something"; nil }
puts s.send(2).inspect

s2 = Axi::Stream(Int32, Int32).new
s2.transform ->(val : Int32) { val * 2 }
puts s2.send(2).inspect

class Foo < Axi::Stream(Int32, Int32)
  def i_transform(val)
    return val ** 2
  end
end

s3 = Foo.new
puts s3.send(5).inspect
