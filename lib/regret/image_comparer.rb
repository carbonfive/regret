require 'chunky_png'

module Regret
  class ImageComparer
    def initialize(image_1_path, image_2_path)
      @image_1 = ChunkyPNG::Image.from_file(image_1_path)
      @image_2 = ChunkyPNG::Image.from_file(image_2_path)
      @width = @image_1.width
      @height = @image_1.height
    end

    def diff
      @diff ||= begin
        mismatches = []

        @image_1.width.times do |x|
          @image_1.height.times do |y|
            if @image_1[x, y] != @image_2[x, y]
              mismatches << [x, y]
            end
          end
        end

        mismatches
      end
    end

    def create_diff_image!
      image = ChunkyPNG::Image.new(
        @width, @height, ChunkyPNG::Color::TRANSPARENT,
      )

      diff.each do |d|
        image[d[0], d[1]] = ChunkyPNG::Color('red')
      end

      image.save('diff.png', interlace: true)
    end

  end
end
