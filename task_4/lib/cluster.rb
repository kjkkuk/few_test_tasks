class Cluster
  def initialize(points)
    @points = points
  end

  def mean
    sum = @points.reduce(Vector[0, 0]) { |acc, point| acc + point }
    sum / @points.size
  end
end
