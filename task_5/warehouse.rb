require 'matrix'

class Warehouse
  attr_reader :rows, :columns, :shelves, :cells

  def initialize(rows, columns, shelves, cells)
    @rows = rows
    @columns = columns
    @shelves = shelves
    @cells = cells
    @warehouse = Array.new(rows) { Array.new(columns) { Array.new(shelves) { Array.new(cells) } } }
  end

  def cell_coordinates(row, column, shelf, cell)
    x = column * cells + cell
    y = row * (shelves + 1) + shelf
    [x, y]
  end

  def find_shortest_path(picking_cells)
    start = [0, 0]
    cells = [start] + picking_cells.map { |cell| cell_coordinates(*cell) }
    path_indices = tsp(cells)
    path_indices.map { |i| cells[i] }
  end

  private

  def distance(coord1, coord2)
    (coord1[0] - coord2[0]).abs + (coord1[1] - coord2[1]).abs
  end

  def tsp(points)
    n = points.size
    all_points = (0...n).to_a
    memo = Array.new(n) { Array.new(1 << n, nil) }
    parent = Array.new(n) { Array.new(1 << n, nil) }

    tsp_helper(0, 1, all_points, points, memo, parent)
    reconstruct_path(parent)
  end

  def tsp_helper(pos, bitmask, all_points, points, memo, parent)
    return 0 if bitmask == (1 << points.size) - 1
    return memo[pos][bitmask] unless memo[pos][bitmask].nil?

    min_cost = Float::INFINITY

    all_points.each do |next_pos|
      next if next_pos == pos || bitmask & (1 << next_pos) != 0

      next_bitmask = bitmask | (1 << next_pos)
      new_cost = distance(points[pos], points[next_pos]) + tsp_helper(next_pos, next_bitmask, all_points, points, memo, parent)

      if new_cost < min_cost
        min_cost = new_cost
        parent[pos][bitmask] = next_pos
      end
    end

    memo[pos][bitmask] = min_cost
  end

  def reconstruct_path(parent)
    n = parent.size
    bitmask = 1
    pos = 0
    path = [pos]

    while bitmask != (1 << n) - 1
      pos = parent[pos][bitmask]
      path << pos
      bitmask |= (1 << pos)
    end

    path
  end
end

# Пример использования
rows = 3
columns = 700
shelves = 5
cells = 6

warehouse = Warehouse.new(rows, columns, shelves, cells)
picking_cells = [
  [0, 0, 0, 0], [0, 1, 2, 3], [2, 5, 1, 4] # Пример ячеек для сбора товаров
]
path = warehouse.find_shortest_path(picking_cells)
puts "Маршрут кладовщика: #{path.map { |x, y| "(#{x}, #{y})" }.join(' -> ')}"
