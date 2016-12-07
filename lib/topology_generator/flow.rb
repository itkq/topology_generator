require 'topology_generator/generator'

module TopologyGenerator
  TMP_PATH = './tmp-topology.tpg'

  class Flow
    attr_accessor :dummy_flows

    def initialize
      @dummy_flows = []
      @topology = nil
    end

    def generate_flow dijkstra_path, size, alpha, random
      generate_flow_template TopologyGenerator::PREPROCESSED_TOPOLOGY_PATH, size, random

      if alpha.class != Fixnum
        STDERR.puts 'Alpha must be integer'
        return
      end

      # if @dummy_flows.empty?
        lines = File.read(TMP_PATH).split("\n")
        e_size = lines[1].to_i
        # @dummy_flows = lines[3+e_size..-1].map{|line| line.split(" ").map(&:to_i) }
      # end

      result = `#{dijkstra_path} < #{TMP_PATH}`
      base_cost = result.split("\n").map{|l| l.split(" ").map(&:to_i).last }.max
      @dummy_flows.map{|f|
        [f[0], f[1], base_cost*alpha].join(" ")
      }
    end

    private
    def generate_flow_template topology_path, size, random
      if File.exists? TMP_PATH
        File.unlink TMP_PATH
      end
      @dummy_flows = []

      begin
        topology = File.read topology_path
      rescue => e
        puts e.message
        return
      end
      @topology = topology

      lines = topology.split("\n")
      v_size = lines[0].to_i
      e_size = lines[1].to_i

      if size <= 0
        STDERR.puts 'size of flow must be greater than 0'
        return
      elsif size > v_size*(v_size-1)
        STDERR.puts 'size of flow exceeds the value'
        return
      end

      _generate_dummy(v_size-1, size, random) if @dummy_flows.empty?
      content = topology + "#{@dummy_flows.size}\n" + @dummy_flows.map{|f| f.join(" ") }.join("\n") + "\n"
      File.write(TMP_PATH, content)
    end

    private
    def _generate_dummy upper, size, random
      @gen = TopologyGenerator::Generator.new(upper, random)
      size.times do
        s,d = @gen.generate_flow_pair
        @dummy_flows << [s,d,0] # dummy cost
      end
    end

  end
end
