using DataStructures
using Graphs, SimpleWeightedGraphs
using Random
using GraphRecipes, Plots, GraphPlot

# Create a simple weighted undirected graph
# I use a graph of probelm 4 in Homework 2 as an example.

g = SimpleWeightedGraph(9)
add_edge!(g, 1, 2, 13)
add_edge!(g, 1, 3, 12)
add_edge!(g, 1, 4, 14)
add_edge!(g, 2, 5, 14)
add_edge!(g, 3, 4, 6)
add_edge!(g, 3, 5, 10)
add_edge!(g, 3, 6, 11)
add_edge!(g, 4, 6, 7)
add_edge!(g, 5, 6, 9)
add_edge!(g, 5, 7, 11)
add_edge!(g, 6, 7, 5)
add_edge!(g, 6, 8, 10)
add_edge!(g, 7, 8, 17)
add_edge!(g, 7, 9, 16)
add_edge!(g, 8, 9, 8)

# Prim's algorithm using a binary heap
function prim(graph)
    # 0. input
    h = MutableBinaryMinHeap{Int}() # create a binary heap 
    n = nv(graph) # number of nodes in the graph
    e = ne(graph) # a number of edges in graph G
    M = 1000      # infty
    l = zeros(1,n) # l_w
    i = zeros(Int64,1,n) # i_w for MutableBinaryMinHeap
    l_v = 0

    #count heap operations
    ho_insert = 0
    ho_decreasekey = 0
    ho_deletemin = 0
    
    # 1. Initialize
    v = rand(1:n) # Choose v in V(G), start node
    T_v = [v]
    T_e = []    

    # l_w = infty for w in V(G) \ {v}
    for w in 1:n 
        if w != v
            l[w] = M
        end
    end
    
    # 2. Iteration
    while length(T_v) != n  
        for w in neighbors(graph, v)
            if w ∉ T_v #If e is not in V(G) \ V(T)
                if get_weight(graph, v, w) < l[w] < M
                    l[w] = get_weight(graph, v, w)
                    update!(h, i[w], l[w] ) # DECREASEKEY(w, l_w)
                    
                    # count heap operations
                    ho_decreasekey = ho_decreasekey + 1
                end

                if l[w] == M
                    l[w] = get_weight(graph, v, w)
                    i[w] = push!( h, l[w] ) # INSERT(w, l_w)
                    
                    # count heap operations
                    ho_insert = ho_insert + 1                
                end 
            end
        end

        #(v, l_v) := DELETEMIN
        new_l_v = top_with_handle(h)[1]    # returns the top value of a heap and its handle
        new_v = findfirst(==(top_with_handle(h)[2]), i)[2]    

        v = new_v 
        l_v = new_l_v
        pop!(h) # deletes the node with handle i from the heap
        
        ho_deletemin = ho_deletemin + 1

        for j in T_v
            if has_edge(graph, (j, new_v)) && get_weight(graph, j, new_v) == l_v
                e = (j, new_v)
            end
        end

        append!(T_v, v) # T_v = T_v + v
        push!(T_e, e) # T_e = T_v + e
    end
    return T_v, T_e, ho_insert, ho_decreasekey, ho_deletemin
end

result = prim(g)
node = result[1]
edge = result[2]
count_insert = result[3]
count_decreasekey = result[4]
count_deletemin = result[5]
count_total = count_insert + count_decreasekey + count_deletemin

println("The nodes of MST : ", sort(node))
println("The edges of MST : ", sort(edge))
println("the count insert opertation : ", count_insert)
println("the count decreasekey operation : ", count_decreasekey )
println("the count deletemin operation : ", count_deletemin)
println("the total count : ", count_total)