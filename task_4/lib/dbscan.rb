require 'matrix'

class DBSCAN
  def initialize(data, eps:, min_points:)
    @data = data
    @eps = eps
    @min_points = min_points
  end

  def run
    clusters = []
    visited = Array.new(@data.size, false)
    @data.each_with_index do |point, index|
      next if visited[index]

      visited[index] = true
      neighbors = region_query(point)
      if neighbors.size >= @min_points
        clusters << expand_cluster(point, neighbors, visited)
      end
    end
    clusters
  end

  private

  def expand_cluster(point, neighbors, visited)
    cluster = [point]
    while neighbors.any?
      neighbor = neighbors.pop
      neighbor_index = @data.index(neighbor)
      next if visited[neighbor_index]

      visited[neighbor_index] = true
      new_neighbors = region_query(neighbor)
      neighbors.concat(new_neighbors) if new_neighbors.size >= @min_points
      cluster << neighbor
    end
    cluster
  end

  def region_query(point)
    @data.select { |other_point| (point - other_point).r < @eps }
  end
end
