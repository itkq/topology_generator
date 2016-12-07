require 'json'
require 'topology_generator/flow'
require 'topology_generator/link'

module TopologyGenerator
  class Topology
    def initialize topology_path, dijkstra_path, size, alpha, l_width=nil
      @topology_path = topology_path
      @dijkstra_path = dijkstra_path
      @size = size
      @alpha = alpha
      @l_width = l_width

      if @l_width
        TopologyGenerator::Link.randomize topology_path, l_width
      else
        TopologyGenerator::Link.normal topology_path
      end

      @manager = TopologyGenerator::Flow.new
    end

    def generate
      random = Random.new
      flows = @manager.generate_flow @dijkstra_path, @size, @alpha, random
      s = flows.size.to_s
      File.read(TopologyGenerator::PREPROCESSED_TOPOLOGY_PATH)+"#{s}\n"+flows.join("\n")
    end
  end
end
