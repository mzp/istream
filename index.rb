#! /usr/bin/env ruby
# -*- mode:ruby; coding:utf-8 -*-
#
# index.rb -
#
# Copyright(C) 2008 by mzp
# Author: MIZUNO Hiroki / mzpppp at gmail dot com
# http://howdyworld.org
#
# Timestamp: 2008/10/22 15:10:12
#
# This program is free software; you can redistribute it and/or
# modify it under MIT Lincence.
#
require 'erb'
require 'optparse'

opt = OptionParser.new
opt.on('-t TITLE','--title=TITLE') {|title| @title=title }
opt.parse!(ARGV)

module Enumerable
  def group_by(*arg)
    result = {}
    self.each(*arg) { |item|
      (result[yield(item)] ||= []) << item
    }
    result
  end
end

class Video
  attr_reader :video,:thumbnail,:title,:subtitle

  def initialize(path)
    @video     = path
    @thumbnail = File.basename path.gsub(/\.[^.]+$/,'.png')

    @title     = File.dirname path
    if path =~ /(第.*」)/ then
      @subtitle = $1
    else
      @subtitla = path
    end
  end
end

@program = ARGV.sort.map{|video|
  Video.new(video)
}.group_by{|x,y|
  File.dirname x.video
}

include ERB::Util
open(File.dirname(__FILE__)+'/template.erb') do|io|
  ERB.new(io.read).run
end
