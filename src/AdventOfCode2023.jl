module AdventOfCode2023
include("./AhoCorasick.jl")

using ArgParse
using Base.Threads
using .AhoCorasick

"""
parse_commandline()

Parse the command-line arguments for the script.

Returns a dictionary containing the parsed command-line arguments. 
Supports '--file' or '-f' for specifying an input file, 
and '--output' or '-o' for specifying an output file.
"""
function parse_commandline()
	s = ArgParseSettings()

	@add_arg_table s begin
		"--file", "-f"
		help = "If you wish the data to be read from an input file please specify it using this flag"
		"--output", "-o"
		help = "File where the data will be outputed to. If not specified, data will be outputed to the STDOUT"
	end

	return parse_args(s)
end

"""
read_data(args::Dict{String, Any})

Read data from the source specified in the `args` dictionary.

If `args` contains a 'file' key, data is read from the specified file.
Otherwise, data is read from the standard input (stdin) until EOF is reached.

Returns an array of strings, each string representing a line of input.
"""
function read_data(args::Dict{String, Any})
	lines = []

	if !isnothing(args["file"])
		open(args["file"], "r") do file
			for line in eachline(file)
				push!(lines, line)
			end
		end
	else
		while !eof(stdin)
		line = readline(stdin)
			push!(lines, line)
	
		end
	end

	return lines
end

"""
output_data(output::Int64, args::Dict{Sting, Any})

Output data to the source specified in the `args` dictionary.

If `args` contains a 'output' key, data is saved to the specified file.
Otherwise, data is displayed in the standart output (stdout).
"""
function output_data(output::Int64, args::Dict{String, Any})
	if !isnothing(args["output"])
		open(args["output"], "w") do file
			write(file, output)
		end
	else
	println(output)
	end
end


"""
calibration_value(s::String)

Recover the calibration value for the elves. The calibration
value is a two digit number on combininb the first and last
digit on the string.
"""
function calibration_value(s::String, root::TrieNode)
	s = aho_corasick_search(s, root)
	return parse(Int64, "$(s[1])$(s[end])")
end

"""
main()

Main function to execute the script logic.

Parses command-line arguments, reads data from the specified source,
filters non-numeric characters from each line of the data,
and prints the processed lines to the standard output.
"""
function main()
	args  = parse_commandline()
	lines = read_data(args)
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

	for i in eachindex(lines)
		lines[i] = calibration_value(lines[i], root)
	end
	
	output = sum(lines)
	output_data(output, args)
end

if abspath(PROGRAM_FILE) == @__FILE__
	main()
end
end

