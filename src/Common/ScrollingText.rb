class ScrollingText

	def initialize(window,x,text,font,sound,&action)
		@x = x
		@text = text
		@font = font
		@action = action
		@sound = sound
	end

	def reset
		@y = 700
	end

	def update
		@y -= 1
	end

	def select
		@sound.play(false)
		@action.call unless @action.nil?
	end

	def draw(window)
		@text.map.with_index do |line,i| 
			@font.draw(line.chomp, @x, @y + @font.height * i, 1.0, 1.0, 1.0) 
		end
	end

end
