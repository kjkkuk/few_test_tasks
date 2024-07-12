require 'json'
require_relative 'dbscan'
require_relative 'cluster'

class GPSDataProcessor
  attr_reader :gps_data, :cleaned_data, :smoothed_data, :route

  def initialize(filepath)
    @filepath = filepath
    @gps_data = []
    @cleaned_data = []
    @smoothed_data = []
    @route = []
  end

  def load_data
    File.foreach(@filepath) do |line|
      data = JSON.parse(line)
      @gps_data << data if data['class'] == 'TPV'
    end
    puts "Loaded #{@gps_data.size} data points"
  end

  def filter_data
    @cleaned_data = @gps_data.select do |data|
      data['mode'] == 3 && !data['lat'].nil? && !data['lon'].nil?
    end
    puts "Filtered down to #{@cleaned_data.size} data points"
  end

  def smooth_data(window_size = 5)
    latitudes = @cleaned_data.map { |data| data['lat'] }
    longitudes = @cleaned_data.map { |data| data['lon'] }

    smoothed_latitudes = moving_average(latitudes, window_size)
    smoothed_longitudes = moving_average(longitudes, window_size)

    @smoothed_data = smoothed_latitudes.zip(smoothed_longitudes).map do |lat, lon|
      { 'lat' => lat, 'lon' => lon }
    end
  end

  def moving_average(data, window_size)
    data.each_cons(window_size).map { |window| window.sum / window.size }
  end

  def cluster_data(eps = 0.0005, min_points = 5)
    coordinates = @smoothed_data.map { |data| Vector[data['lat'], data['lon']] }
    dbscan = DBSCAN.new(coordinates, eps: eps, min_points: min_points)
    clusters = dbscan.run
    @route = clusters.map { |cluster| Cluster.new(cluster).mean }
  end

  def save_route(output_path)
    File.open(output_path, 'w') do |file|
      @route.each do |point|
        file.puts({ 'lat' => point[0], 'lon' => point[1] }.to_json)
      end
    end
  end
end
