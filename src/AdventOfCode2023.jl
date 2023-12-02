module AdventOfCode2023
include("./Solutions.jl")

using .Solutions
using ArgParse
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
		"--day", "-d"
		help = "Day of the advent of code challenge"
		arg_type = Int
		required = true
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
function output_data(output::Any, args::Dict{String, Any})
	if !isnothing(args["output"])
		open(args["output"], "w") do file
			write(file, output)
		end
	else
	println(output)
	end
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
	output = solve(lines, args["day"])	
	output_data(output, args)
end

if abspath(PROGRAM_FILE) == @__FILE__
	main()
end
end

