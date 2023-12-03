module Solutions
using Match

# ------------------------------ Day 1 ------------------------------ 
include("./AhoCorasick.jl")
using .AhoCorasick


"""
calibration_value(s::String, root::TrieNode)

Recover the calibration value for the elves. The calibration
value is a two digit number on combining the first and last
digit on the string.
"""
function calibration_value(s::String, root::TrieNode)
	s = aho_corasick_search(s, root)
	return parse(Int64, "$(s[1])$(s[end])")
end

function day_1_solution(data)
	patterns = [
		("0", 0), ("1", 1), ("2", 2), ("3", 3), 
		("4", 4), ("5", 5), ("6", 6), ("7", 7), 
		("8", 8), ("9", 9), ("zero", 0), ("one", 1), 
		("two", 2), ("three", 3), ("four", 4), ("five", 5), 
		("six", 6), ("seven", 7), ("eight", 8), ("nine", 9)
	]

	root = TrieNode()
	for (k, v) in patterns
		insert_pattern!(root, k, v)
	end
	build_failure_function!(root)

	solution = Vector{Int64}(undef, length(data))
	for i in eachindex(data)
		solution[i] = calibration_value(data[i], root)
	end

	return sum(solution)
end


# ------------------------------ Day 2 ------------------------------ 
function parse_game(line)
	game_id_str, games_str = split(line, ":")
	game_id = parse(Int, split(game_id_str, " ")[2])

	games = Dict("red" => [], "green" => [], "blue" => [])

	for game_str in split(games_str, ";")
		game = map(
			x -> split(lstrip(x), " "),
			split(game_str, ",")
		)
		for cube in game
		append!(games[cube[2]], parse(Int, cube[1]))
		end
	end
	return game_id, games
end

function is_valid_game(game)
return (
	all(x -> x <= 12, game["red"]) &&
		all(x -> x <= 13, game["green"]) &&
		all(x -> x <= 14, game["blue"]) 
	)
end

function minimum_n_cubes_powerset(game)
return (
	maximum(game["red"]) * 
		maximum(game["green"]) * 
		maximum(game["blue"])
	)
end

function day_2_solution(data)
	total = 0
	for line in data
		id, game = parse_game(line)
		total += minimum_n_cubes_powerset(game)
	end
	return total
end

# ------------------------------ Day 3 ------------------------------ 
function issymbol(c::Char)
	return !isdigit(c) && c != '.'
end


function day_3_solution(data)
	total = 0

	# Use length instead of size because data is a 
	# list of Strings
	m = length(data)
	n = length(data[1])

	for (i, line) in enumerate(data)
		is_num = false
		adjecent_to_symbol = false
		num_start = -1

		for (j, ch) in enumerate(line)
			if isdigit(ch)
				# Check if it is the begining of a number
				if !is_num
					is_num = true
					num_start = j
				end

				# Check if there are any symbols adjencent to the number
				adjecent_to_symbol = (
					adjecent_to_symbol ||                            # Short-Circuit if we already know it's adjecent 
					(j > 1 && issymbol(line[j-1])) ||                # Left
					(j < n && issymbol(line[j+1])) ||                # Right
					(i > 1 && issymbol(data[i-1][j])) ||             # Up
					(i > 1 && j > 1 && issymbol(data[i-1][j-1])) ||  # Up-Left
					(i > 1 && j < m && issymbol(data[i-1][j+1])) ||  # Up-Right
					(i < m && issymbol(data[i+1][j])) ||             # Down
					(i < m && j > 1 && issymbol(data[i+1][j-1])) ||  # Down-Left
					(i < m && j < m && issymbol(data[i+1][j+1]))     # Down-Right
				)

				# If it's the last charactere we need to parse the number here
				# only parses if number is adjecent 
				if adjecent_to_symbol && j == n
					total += parse(Int, line[num_start:j])
					is_num = false
					num_start = -1
					adjecent_to_symbol = false
				end
			elseif is_num
				# Represents the end if a number
				# only parses the number if it is ajecent to a symbol
				if adjecent_to_symbol
					total += parse(Int, line[num_start:j-1])
				end
				is_num = false
				adjecent_to_symbol = false
				num_start = -1
			end
		end
	end

	return total
end



# ------------------------------ Solver ------------------------------ 
function solve(data, day::Int)
	output =  nothing
	@match day begin
		1     => begin 
			output = day_1_solution(data)
		end
		2     => begin
			output = day_2_solution(data)
		end
		3     => begin
			output = day_3_solution(data)
		end
		_     =>  println("Invalid day")
	end	

	return output
end

export solve

end
