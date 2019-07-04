# frozen_string_literal: true

class Node
  attr_accessor :value, :parent, :left, :right
  def initialize(value = nil, parent = nil)
    @value = value
    @parent = parent
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root
  def initialize
    @root = Node.new
  end

  def root_empty_check(node)
    if @root.value.nil?
      @root = node
      puts "Root Eklendi. Value: #{@root.value}"
      true
    end
  end

  def side_node_add(current, node, side)
    if current.send(side).nil?
      current.send("#{side}=", node)
      node.parent = current
      puts "Node Eklendi. Value: #{current.send(side).value} Parent: #{node.parent.value}"
    else
      current.send(side)
    end
  end

  def add_node(node)
    return if root_empty_check(node)

    current = @root
    previous = nil
    until current.nil?
      previous = current
      current = if node.value > current.value
                  side_node_add(current, node, 'right')
                else
                  side_node_add(current, node, 'left')
                end
      end
    current = node
    current.parent = previous
  end

  def root_node_distance(node)
    distance = 0
    until node == @root
      node = node.parent
      distance += 1
    end
    distance
  end

  def get_all_nodes
    que = [@root]
    all_nodes = []
    until que.empty?
      node = que.shift
      all_nodes.push(node)
      que.push(node.left) unless node.left.nil?
      que.push(node.right) unless node.right.nil?
    end
    all_nodes
  end

  def get_nodes_by_level
    all_nodes = get_all_nodes
    by_level = Array.new(root_node_distance(all_nodes[-1]) + 1) { Array.new(0) }
    all_nodes.each do |node|
      by_level[root_node_distance(node)].push(node.value)
    end
    by_level
  end

  def to_s
    total = ''
    node_array_by_level = get_nodes_by_level
    node_array_by_level.each do |level|
      str = ''
      level.each do |value|
        str += "#{value} "
      end
      total += "#{str}\n"
    end
    total
  end

  def breadth_first_search(target)
    que = [@root]
    until que.empty?
      node = que.shift
      if node.value == target
        return node
      else
        puts "Value: #{node.value} Visited."
        que.push(node.left) unless node.left.nil?
        que.push(node.right) unless node.right.nil?
      end
    end
    nil
  end

  def depth_first_search(target)
    stack = [@root]
    until stack.empty?
      node = stack.pop
      if node.value == target
        return node
      else
        stack.push(node.left) unless node.left.nil?
        stack.push(node.right) unless node.right.nil?
      end
    end
    nil
  end

  def dfs_rec(target,current_node=@root)
    return current_node if target == current_node.value
    dfs_rec(target,current_node.left) unless current_node.left.nil?
    dfs_rec(target,current_node.right) unless current_node.right.nil?
  end

end

tree = Tree.new

def build_tree(arr, tree)
  arr.each do |element|
    new_node = Node.new(element)
    tree.add_node(new_node)
  end
end

build_tree([10, 5, 20, 6, 50, 15, 4],tree)
