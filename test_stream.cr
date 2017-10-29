require "./src/axi"

s = Axi::Stream(Int32, Int64).new
puts s.send(2).inspect
s.transform ->(val : Int32) { val.to_i64 }
s.on_transform ->(ival : Int32, oval : Int64) { "do something"; nil }
puts s.send(2).inspect

s2 = Axi::Stream(Int32, Int32).new
s2.transform ->(val : Int32) { val * 2 }
puts s2.send(2).inspect
