require './Common/TextItem.rb'

class Menu

	attr_accessor :selected

	def initialize(window,x,y,title,font,sound)
		@x = x
		@y = y
		@title = title
		@items = []
		@font = font
		@sound = sound
		@selected = 0
		@padding = 10
		@timeout = 0
		@max_length = 0
	end

	def add_item(name,value)
		@items.push(TextItem.new(name,@items.length+1,value))
		@max_length = @items.map{ |item| item.value.nil? ? item.text : item.text + ' ' + item.value.to_s}.
			group_by(&:size).max.first
	end

	def update
		@timeout += 1 if @timeout < IDLE_TIME
	end

	def increment_value
		if @timeout == IDLE_TIME then
			@items[@selected].value += 1
			@timeout = 0
			@sound.play(false)
		end
	end

	def decrement_value
		if @timeout == IDLE_TIME then
			@items[@selected].value -= 1
			@timeout = 0
			@sound.play(false)
		end
	end

	def next
		if @timeout == IDLE_TIME then
			@selected = (@selected + 1) % @items.length
			@timeout = 0
			@sound.play(false)
		end
	end

	def prev
		if @timeout == IDLE_TIME then
			@selected = (@selected - 1) % @items.length
			@timeout = 0
			@sound.play(false)
		end
	end

	def draw(window)
		selectedColor = Color.new(255,0,0,100)
		backgroundColor = Color.new(255,80,80,80)
		window.draw_quad(@x - @padding,
										 @y - @padding,
										 backgroundColor,
										 @x + @padding + @max_length * @font.height,
										 @y - @padding,
										 backgroundColor,
										 @x - @padding,
										 @y + (@items.length + 1) * @font.height + @padding,
										 backgroundColor,
										 @x + @padding + @max_length * @font.height,
										 @y + (@items.length+1)*@font.height + @padding,
										 backgroundColor)
		@font.draw(@title, @x, @y, 1.0, 1.0, 1.0)
		@items.map{ |item| item.draw(window,@x,@y,@font,@max_length,@selected) }
	end

end
