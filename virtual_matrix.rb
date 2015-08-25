#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# 仮想的な無限格子空間
class VirtualMatrix
  def initialize(default_val=nil)
    @default_val = default_val
    @pos = Hash.new(@default_val)
    @delim = ":"
  end
  def buildkey(x, y)
    "#{x}#{@delim}#{y}"
  end
  alias _ buildkey
  def sepkey(k)
    k.split(@delim).map(&:to_i)
  end
  def [](x, y)
    @pos[_(x, y)]
  end
  def []=(x, y, n)
    @pos[_(x, y)] = n
    # puts "#{_(x, y)} = #{n}"
  end
  # def set(x, y)
  #   self[x, y] = 1
  # end
  def del(x, y)
    @pos.delete _(x, y)
  end
  def vacuum
    @pos.each {|k, v| @pos.delete(k) if v == @default_val || v.nil? }
    self
  end
  def clear
    @pos.clear
  end
  def dump
    @pos.each do |k, v|
      x, y = sepkey(k)
      puts "#{x}, #{y} -> #{v}"
    end
  end
  def print_matrix(hash={})
    range = box
    # puts "(#{range[:xmin]},#{range[:ymin]})"
    (range[:ymin]..range[:ymax]).each do |y|
      (range[:xmin]..range[:xmax]).each do |x|
        v = self[x, y]
        print "#{hash[v]||v}"
      end
      puts
    end
    # puts "(#{range[:xmax]},#{range[:ymax]})"
  end
  def positions
    @pos.keys.map do |k|
      x, y = sepkey(k)
      [x.to_i, y.to_i]
    end
  end

  def box
    return nil if @pos.size == 0
    xs = []
    ys = []
    positions.each do |x, y|
      xs << x
      ys << y
    end
    # [[xs.min, ys.min], [xs.max, ys.max]]
    { xmin: xs.min, ymin: ys.min, xmax: xs.max, ymax: ys.max }
  end

  def rotate
    des = VirtualMatrix.new(@default_val)
    @pos.each do |k,v|
      x, y = sepkey(k)
      des[-y, x] = v
    end
    des
  end
  alias rotate_clockwise rotate

  def rotate_ccw
    des = VirtualMatrix.new(@default_val)
    @pos.each do |k,v|
      x, y = sepkey(k)
      des[y, -x] = v
    end
    des
  end

  def mirror
    des = VirtualMatrix.new(@default_val)
    @pos.each do |k,v|
      x, y = sepkey(k)
      des[-x, y] = v
    end
    des
  end

  def dup
    des = VirtualMatrix.new(@default_val)
    @pos.each do |k,v|
      x, y = sepkey(k)
      des[x, y] = v
    end
    des#.vacuum
  end

  def serialize
    des = []
    range = box
    (range[:ymin]..range[:ymax]).each do |y|
      xs = []
      (range[:xmin]..range[:xmax]).each do |x|
        xs << self[x, y]
      end
      des << xs.join
    end
    des.join("/")
  end
  alias to_s serialize

  def normalize
    des = VirtualMatrix.new(@default_val)
    range = box
    (range[:ymin]..range[:ymax]).each.with_index do |y,yi|
      (range[:xmin]..range[:xmax]).each.with_index do |x,xi|
        des[xi, yi] = self[x, y]
      end
    end
    des
  end

  def conv(h={1 => 2, 2 => 1})
    des = VirtualMatrix.new(@default_val)
    @pos.each do |k,v|
      x, y = sepkey(k)
      des[x, y] = h.keys.include?(v) ? h[v] : v
    end
    des
  end
end
