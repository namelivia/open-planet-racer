class ScrollingText

	def initialize(window,x,text_path,font_size)
		@x = x
		@text_path = text_path
		@font_size = font_size
		@font = Gosu::Font.new(window, "../media/fonts/press-start-2p.ttf", @font_size)
	end

	def reset
		@y = 700
	end

	def update
		@y -= 1
	end

	def draw(window)
		File.readlines(@text_path).map.with_index do |line,i| 
			@font.draw(line.chomp, @x, @y + @font_size * i, 1.0, 1.0, 1.0) 
		end
	end

end
