#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative "virtual_matrix"

class Solver
  def initialize(n)
    @num = n
    @result = []
    @count = 0
    @area = VirtualMatrix.new
  end

  def print_area
    @area.print_matrix(0 => "  ", 1 => "＼", 2 => "／")
    # @area.print_matrix
  end

  def solve!
    sub(0, 0, 1, 0)
    @count
  end

  def same_pattern?
    a1 = @area
    4.times do
      a1 = a1.rotate
      return true if @result.include?(a1.to_s)
      a2 = a1.mirror
      return true if @result.include?(a2.to_s)
    end
    @result << @area.to_s
    false
  end

  def sub(x, y, m, dep)
    # puts "#{x}, #{y}, #{m}, #{dep}"
    if @num == dep
      return if same_pattern?
      @count += 1
      puts "-------------------- (#{@count})"
      print_area
      return
    end
    return if @area[x, y]
    @area[x, y] = m
    if m == 1
      sub(x-1, y-1, 1, dep+1)
      sub(x+1, y+1, 1, dep+1)
    elsif m == 2
      sub(x+1, y-1, 2, dep+1)
      sub(x-1, y+1, 2, dep+1)
    end
    sub(x-1, y,   3-m, dep+1)
    sub(x+1, y,   3-m, dep+1)
    sub(x,   y-1, 3-m, dep+1)
    sub(x,   y+1, 3-m, dep+1)
    @area.del(x, y)
  end
end

# (1..6).each do |i|
#   puts "#{i}本 #{Solver.new(i).solve!}通り"
# end

p Solver.new(5).solve!
