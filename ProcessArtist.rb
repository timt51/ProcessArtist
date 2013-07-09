#A new line.
#Another new line.
require 'ruby-processing'
class ProcessArtist < Processing::App

	def setup
		background(148, 0, 211)
		@size = 20
		@fill = fill(255, 255, 0)
		@stroke = stroke(255, 255, 0)
	end

	def my_shape
		if @shape_set_times == 1
			case @shape
			when 's1' then oval(mouse_x, mouse_y, @size, @size)
			when 's2' then oval(mouse_x, mouse_y, @size * 2, @size)
			when 's3' then oval(mouse_x, mouse_y, @size, @size * 2)
			when 's4' then rect(mouse_x, mouse_y, @size, @size)
			when 's5' then rect(mouse_x, mouse_y, @size * 4, @size)
			when 's6' then rect(mouse_x, mouse_y, @size, @size * 4)
			when 's7' then
				rect(mouse_x, mouse_y, @size * 2, @size)
				stroke_weight(0)
				rect(mouse_x, mouse_y, @size, @size * 2)
			when 's8' then
				stroke_weight(0)
				oval(mouse_x - (@size / 2), mouse_y - (@size / 2), @size * 2, @size * 2)
				oval(mouse_x + (@size / 2), mouse_y - (@size / 2), @size * 2, @size * 2)
				oval(mouse_x - (@size / 2), mouse_y + (@size / 2), @size * 2, @size * 2)
				oval(mouse_x + (@size / 2), mouse_y + (@size / 2), @size * 2, @size * 2)
			when 's9' then
				oval(mouse_x, mouse_y, @size, @size)
			else
				warn "Invalid shape selected!"
			end
		else
			warn "Shape not set!"
		end
	end

	def draw
		ellipse_mode CENTER
		rect_mode CENTER
		smooth
	end

	def mouse_pressed
		warn "Mouse!"
		@fill
		default_or_set
	end

	def mouse_dragged
		warn "Mouse dragged"
		@fill
		default_or_set
	end

	def default_or_set
		if @shape_set_times.nil?
			@stroke
			oval(mouse_x, mouse_y, @size, @size)
		else
			my_shape
		end
	end

	def mouse_released
		warn "Mouse released!"
		if !@a_count.nil? && !@a_count.to_i.even?
			run_command("c")
		end
	end

	def key_pressed
		warn "A key was pressed! #{key.inspect}"
		@queue ||= ""
		if key.is_a? String
			if key != "\n"
				@queue = @queue + key
			else
				warn "Time to run the command: #{@queue}"
				run_command(@queue)
				@queue = ""
			end
		end
	end

	def run_command(command)
		puts "Running Command #{command}"
		command_as_array = command.split(",")
		command_key = command_as_array[0].split("")[0]
			case command_key
			when 'b' then background(command_as_array[0][1..-1].to_i, command_as_array[1].to_i, command_as_array[2].to_i)
				@background_color_changed = true
				@background_RGB = command
				@background_RGB_array = @background_RGB.split(",")
			when 'f' then @fill = fill(command_as_array[0][1..-1].to_i, command_as_array[1].to_i, command_as_array[2].to_i)
				@stroke = stroke(command_as_array[0][1..-1].to_i, command_as_array[1].to_i, command_as_array[2].to_i)
			when '+' then @size += 1
			when '-' then @size -= 1
			when 's' then 
				@shape = @queue
				my_shape
				@shape_set_times = 1
			when 'c' then background_RGB
			when 'e' then eraser
			when 'a' then @a_count = @a_count.to_i + 1
			else
				puts "Sorry, invalid command"
		end
	end

	def background_RGB
		if @background_color_changed
			background(@background_RGB_array[0][1..-1].to_i, @background_RGB_array[1].to_i, @background_RGB_array[2].to_i)
		else
			background(148, 0, 211)
		end
	end

	def eraser
		if @background_color_changed
			@fill = fill(@background_RGB_array[0][1..-1].to_i, @background_RGB_array[1].to_i, @background_RGB_array[2].to_i)
		else
			@stroke = stroke(148, 0, 211)
			@fill = fill(148, 0, 211)
		end
	end
end

ProcessArtist.new(:width => 800, :height => 800, 
	:title => "ProcessArtist", :full_screen => false)
