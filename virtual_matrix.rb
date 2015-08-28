#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# 仮想的な無限格子空間
class VirtualMatrix
  Pos = Struct.new(:x, :y, :v)
  def initialize
    @pos = Hash.new
  end
  def buildkey(x, y)
    "#{x}/#{y}"
  end
  alias _ buildkey
  def [](x, y)
    p = @pos[_(x, y)]
    p.nil? ? nil : p.v
  end
  def []=(x, y, v)
    @pos[_(x, y)] = Pos.new(x, y, v)
  end
  def del(x, y)
    @pos.delete(_(x, y))
  end
  def clear
    @pos.clear
  end
  def dump
    @pos.each do |k, v|
      puts "#{v.x}, #{v.y} -> #{v.v}"
    end
  end
  def print_matrix(hash={0 => "  ", 1 => "＼", 2 => "／"})
    range = box
    (range[:ymin]..range[:ymax]).each do |y|
      (range[:xmin]..range[:xmax]).each do |x|
        v = self[x, y] || 0
        print "#{hash[v]||v}"
      end
      puts
    end
  end
  def positions
    @pos.values.map {|v| [v.x, v.y] }
  end

  def box
    return nil if @pos.size == 0
    xs = []
    ys = []
    positions.each do |x, y|
      xs << x
      ys << y
    end
    { xmin: xs.min, ymin: ys.min, xmax: xs.max, ymax: ys.max }
  end

  def rotate
    des = VirtualMatrix.new
    @pos.each do |_,v|
      des[-v.y, v.x] = 3 - v.v
    end
    des
  end

  def mirror
    des = VirtualMatrix.new
    @pos.each do |_,v|
      des[-v.x, v.y] = 3 - v.v
    end
    des
  end

  def serialize
    des = []
    range = box
    (range[:ymin]..range[:ymax]).each do |y|
      xs = []
      (range[:xmin]..range[:xmax]).each do |x|
        xs << (self[x, y] || 0)
      end
      des << xs.join
    end
    des.join("/")
  end
  alias to_s serialize
end
