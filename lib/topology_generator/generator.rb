module TopologyGenerator
  class Generator
    class FlowNotFoundException < StandardError; end

    def initialize size, random
      @random = random || Random.new
      @size = size
      @uniq_cnt = 0
      @flow_map = {}
      size.times do |i|
        @flow_map[i] = {}
        size.times do |j|
          @flow_map[i][j] = 0
        end
      end
    end

    def generate_flow_pair
      if !unique_flow_exists?
        raise FlowNotFoundException
      end

      ret = nil
      while ret == nil do
        lower = 0
        upper = @size-1
        s = @random.rand(lower..upper)
        d = @random.rand(lower..upper)
        ret = [s,d] if s != d && @flow_map[s][d] != 1
      end

      @flow_map[s][d] = 1
      @uniq_cnt += 1

      ret
    end

    private
    def unique_flow_exists?
      @uniq_cnt < @size*(@size-1)
    end

  end
end
