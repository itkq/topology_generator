require 'json'
require 'topology_generator/flow'
require 'topology_generator/link'

module TopologyGenerator
  class Topology
    def self.generate topology_path, dijkstra_path, size, alpha, l_width=nil
      if l_width
        TopologyGenerator::Link.randomize topology_path, l_width
      else
        TopologyGenerator::Link.normal topology_path
      end

      manager = TopologyGenerator::Flow.new
      topology = manager.generate_flow size, alpha, dijkstra_path
      topology.join("\n")
    end
  end
end
