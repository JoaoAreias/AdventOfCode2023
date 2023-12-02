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
		_     =>  println("Invalid day")
	end	

	return output
end

export solve

end
