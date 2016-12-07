module TopologyGenerator
  PREPROCESSED_TOPOLOGY_PATH = './preprocessed_topology.tpg'

  class Link
    def self.normal topology_path
      `cp #{topology_path} #{PREPROCESSED_TOPOLOGY_PATH}`
    end

    def self.randomize topology_path, width
      r = Random.new
      lines = File.read(topology_path).split("\n")
      fixed_cost = lines[2].split(" ").last.to_i

      output = (lines[0..1] + lines[2..-1].map{|l|
        s,d,c = l.split(" ").map(&:to_i)
        [s,d,random_width(r, fixed_cost, width)].join(" ")
      }).join("\n")+"\n"

      File.write(PREPROCESSED_TOPOLOGY_PATH, output)
    end

    def self.random_width r, cost, width
      (cost + r.rand(0..cost * width*2) - cost * width).to_i
    end
  end
end
