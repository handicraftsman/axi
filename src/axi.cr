module Axi
  VERSION = "0.1.0"

  class Stream(I, O)
    def initialize
      @on_transform_blocks = [] of Proc(I, O, Nil)
      @linked_channels = [] of Channel(O)
    end

    def send(val : I, async = false) : Stream(I, O) | O | Nil
      if async
        spawn do
          self.send(val, false)
        end
        self
      else
        tval = self.transform(val)
        if tval.is_a?(O)
          @on_transform_blocks.each do |block|
            block.call(val, tval)
          end
          if self.responds_to?(:i_on_transform)
            self.i_on_transform(val, tval)
          end
          @linked_channels.each do |chan|
            chan.send(tval)
          end
          tval
        else
          nil
        end
      end
    end

    def send_async(val : I) : Stream(I, O)
      send(val, true)
    end

    def link(chan : Channel(O))
      @linked_channels << chan
    end

    def link(target)
      self.on_transform ->(val : I, tval : I) { target.send(tval); nil }
    end

    def on_transform(block : Proc(I, O, Nil))
      @on_transform_blocks << block
    end

    def transform(block : Proc(I, O))
      @transform_block = block
    end

    def transform(val : I) : I | O | Nil
      if (tb = @transform_block).is_a?(Proc(I, O))
        return tb.call(val)
      elsif (tb = @transform_block).is_a?(Nil)
        if self.responds_to?(:fn_transform)
          return self.fn_transform(val)
        elsif (I == O)
          return val
        else
          return nil
        end
      end
    end
  end
end
