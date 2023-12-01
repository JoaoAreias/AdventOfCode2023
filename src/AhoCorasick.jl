module AhoCorasick
using DataStructures

mutable struct TrieNode
        children::Dict{Char, TrieNode}
	failure_node::Union{TrieNode, Nothing}
        is_end_of_word::Bool
        value::Union{Int64, Nothing}

        TrieNode() = new(Dict{Char, TrieNode}(), nothing, false, nothing)
end

function insert_pattern!(root::TrieNode, word::String, value::Int64)
        node = root
        for ch in word
                if !haskey(node.children, ch)
                        node.children[ch] = TrieNode()
                end
                node = node.children[ch]
        end
        node.is_end_of_word = true
        node.value = value
end

function build_failure_function!(root::TrieNode)
        queue = Queue{TrieNode}()
        for child in values(root.children)
                child.failure_node = root
                enqueue!(queue, child)
        end

        while !isempty(queue)
                current_node = dequeue!(queue)
                for (ch, child_node) in current_node.children
                        enqueue!(queue, child_node)
                        failure_node = current_node.failure_node

                        while !isnothing(failure_node) && !haskey(failure_node.children, ch)
                                failure_node = failure_node.failure_node
                        end

                        child_node.failure_node = isnothing(failure_node) ? root : failure_node.children[ch]
			child_node.value = isnothing(child_node.failure_node.value) ? child_node.value : child_node.failure_node.value
			
                end
        end
end

function aho_corasick_search(text::String, root::TrieNode)
        results = Int64[]
        node = root

        for ch in text
                while !isnothing(node) && !haskey(node.children, ch)
                        node = node.failure_node
                end
                node = isnothing(node) ? root : node.children[ch]
                if node.is_end_of_word && !isnothing(node.value)
                        append!(results, node.value)
                end
        end
        return results
end

export TrieNode, insert_pattern!, build_failure_function!, aho_corasick_search
end

