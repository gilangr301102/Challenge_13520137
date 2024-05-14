require 'benchmark'

INF = 1_000_000_000
MAXN = 20

def tsp(mask, pos, adj, dp, next_node, n)
  if mask == (1 << n) - 1
    return adj[pos][0] # Return to the start point
  end

  return dp[mask][pos] if dp[mask][pos] != -1

  ans = INF
  (0...n).each do |v|
    if (mask & (1 << v)) == 0
      curr = adj[pos][v] + tsp(mask | (1 << v), v, adj, dp, next_node, n)
      if curr < ans
        ans = curr
        next_node[mask][pos] = v # Store the next node in the path
      end
    end
  end
  dp[mask][pos] = ans
  ans
end

def print_path(start, next_node, n)
  mask = 1
  pos = start
  print "Path: #{pos + 1} "
  while mask != (1 << n) - 1
    pos = next_node[mask][pos]
    mask |= (1 << pos)
    print "-> #{pos + 1} "
  end
  puts "-> 1" # Return to the start point
end

def print_matrix(matrix, n, m)
  puts "Adjacency Matrix:"
  (0...n).each do |i|
    (0...m).each do |j|
      print matrix[i][j] == INF ? "INF".ljust(5) : matrix[i][j].to_s.ljust(5)
    end
    puts
  end
end

def solve
  puts "Choose a test case (1, 2, or 3):"
  choice = gets.chomp.to_i

  case choice
  when 1
    n = 4
    m = 4
    foo = [
      0, 10, 15, 20,
      5, 0, 9, 10,
      6, 13, 0, 12,
      8, 8, 9, 0
    ] # Test case 1
  when 2
    n = 5
    m = 5
    foo = [
      INF, 20, 30, 10, 11,
      15, INF, 16, 4, 2,
      3, 5, INF, 2, 4,
      19, 6, 18, INF, 3,
      16, 4, 7, 16, INF
    ] # Test case 2
  when 3
    n = 7
    m = 7
    foo = [
      0, 12, 10, INF, INF, INF, 12,
      12, 0, 8, 12, INF, INF, 12,
      10, 8, 0, 11, 3, INF, 9,
      INF, 12, 11, 0, 11, 10, INF,
      INF, INF, 3, 11, 0, 6, 7,
      INF, INF, INF, 10, 6, 0, 9,
      12, INF, 9, INF, 7, 9, 0
    ] # Test case 3
  else
    puts "Invalid choice"
    return
  end

  adj = Array.new(n) { Array.new(m, 0) }
  dp = Array.new(1 << MAXN) { Array.new(MAXN, -1) }
  next_node = Array.new(1 << MAXN) { Array.new(MAXN, -1) }

  (0...n).each do |i|
    (0...m).each do |j|
      adj[i][j] = foo[i * m + j]
    end
  end

  print_matrix(adj, n, m)

  min_cost = nil
  time = Benchmark.realtime do
    min_cost = tsp(1, 0, adj, dp, next_node, n)
  end

  puts "The shortest path has length #{min_cost}"
  puts "Execution time: #{time.round(6)} seconds"
  print_path(0, next_node, n) # Print the path starting from node 0
end

solve
