class TextItem

	attr_accessor :text
	attr_accessor :value

	def initialize(text,order,value)
		@text = text
		@order = order
		@value = value
	end

	def draw(window,x,y,font,max_length,selected)
		offset = @order * font.height
		item_length = max_length * font.height
		if selected+1 == @order then
		 	background_color = Color.new(255,110,110,110)
		 	text_color = Color.new(255,255,255,0)
		else 
			background_color = Color.new(255,150,150,150)
			text_color = Color.new(255,255,255,255)
		end
		window.draw_quad(x,
										 y + offset,
										 background_color,
										 x + item_length,
										 y + offset,
										 background_color,
										 x,
										 y + offset + font.height,
										 background_color,
										 x + item_length,
										 y + offset + font.height,
										 background_color) 
		font.draw("#{@text} #{@value}",x,y+offset, 1.0, 1.0, 1.0,text_color)
	end

end
