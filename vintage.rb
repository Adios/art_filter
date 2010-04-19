#!/usr/bin/env ruby
# This software is licensed under the CC-GNU GPL.
# (http://creativecommons.org/licenses/GPL/2.0/)
#             Tzu-Hao Tsai (Adios)

#
# A vintage-look filter from the GIMP script.
#
# reference: mm1-vintage-look.0.3_0.scm
#

require 'rubygems'
require 'RMagick'

def vintager src, dest, opts = {}
  include Magick

  opacity = { :yellow => 59, :magenta => 20, :cyan => 17 }.merge(opts)

  src = Image.read(src).first
  bleach = src.quantize(256, GRAYColorspace).gaussian_blur(1, 1).unsharp_mask(1, 1, 1, 0)
  yellow = Image.new(src.columns, src.rows) { self.background_color = 'rgb(251, 242, 163)' }
  magenta = Image.new(src.columns, src.rows) { self.background_color = 'rgb(232, 101, 179)' }
  cyan= Image.new(src.columns, src.rows) { self.background_color = 'rgb(9, 73, 233)' }

  yellow.opacity = QuantumRange * (1 - opacity[:yellow] / 100.0)
  magenta.opacity = QuantumRange * (1 - opacity[:magenta] / 100.0)
  cyan.opacity = QuantumRange * (1 - opacity[:cyan] / 100.0)

  src.composite(bleach, 0, 0, OverlayCompositeOp).
    composite(yellow, 0, 0, MultiplyCompositeOp).
    composite(magenta, 0, 0, ScreenCompositeOp).
    composite(cyan, 0, 0, ScreenCompositeOp).
    write(dest) { self.quality = 100 }
end

if __FILE__ == $0
  vintager 'tomato.jpg', 'result.jpg'
end

# vim:sts=2 sw=2 expandtab:
