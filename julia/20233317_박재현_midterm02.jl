using DataStructures
using Graphs
using Random
using SimpleValueGraphs
using GraphRecipes, Plots, GraphPlot

# VISIT1(v)
function VISIT1(var, graph, linked_list)
    # Use global variable
    global M 
    global R_1
    global ψ
    global ψ_inv

    append!(R_1, var) # R ← R ⋃ {v}
    for w in linked_list[var].tail # neighbors(graph, var) # (v,w) only neighbor, not (w,v)
        if w ∉ R_1
            VISIT1(w, graph,linked_list)
        end
    end
    
    M = M + 1
    ψ[var] = M
    ψ_inv[M] = var  
end

# VISIT2(v)
function VISIT2(var, graph, linked_list)
    # Use global variable
    global K
    global R_2
    global comp

    append!(R_2, var) # R ← R ⋃ {v}
    for w in linked_list[var].tail # inneighbors(graph, var) # (w,v) only in-neighbor, not (v,w)
        if w ∉ R_2
            VISIT2(w, graph, linked_list)
        end
    end
    comp[var] = K  
end

# Strongly Connected Component algorithm
function SCCA(graph)
    # Initialize

    # Use global variable
    global n = nv(graph) # the size of nodes in the graph
    global ψ = zeros(1,n)
    global ψ_inv =  zeros(Int64,1,n)
    global comp = zeros(Int64,1,n)

    # generate adjacency matrix
    adj = adjacency_matrix(graph)

    # generate linked list for VISIT1 such that w ∈ (v,w)
    l = []
    for i in 1:nv(graph)
        push!(l, list(i)) 
        for j in reverse(1:nv(graph))
            if adj[i,j] == 1
                l[i].tail = cons(j, l[i].tail) 
            end
        end
    end

    # generate linked list for VISIT2 such that w ∈ (w,v)
    l_reverse = []
    for i in 1:nv(graph)
        push!(l_reverse, list(i)) 
        for j in reverse(1:nv(graph))
            if adj[j,i] == 1
                l_reverse[i].tail = cons(j, l_reverse[i].tail) 
            end
        end
    end
    
    # Set 1
    global R_1 = []
    global M = 0
    
    # Loop 1
    for v in 1:n
        if v ∉ R_1
            VISIT1(v, graph, l)
        end
    end

    # Set 2
    global R_2 = []
    global K = 0

    # Loop 2
    for i in reverse(1:n)
        if ψ_inv[i] ∉ R_2
            K = K + 1
            VISIT2(ψ_inv[i], graph, l_reverse)
        end
    end
    return comp
end


# EX 1
g = SimpleDiGraph(7)
add_edge!(g, 1, 7)
add_edge!(g, 2, 1)
add_edge!(g, 3, 4)
add_edge!(g, 3, 7)
add_edge!(g, 4, 5)
add_edge!(g, 5, 4)
add_edge!(g, 6, 1)
add_edge!(g, 6, 5)
add_edge!(g, 7, 2)
add_edge!(g, 7, 4)
add_edge!(g, 7, 5)
add_edge!(g, 7, 6)

result1 = SCCA(g)

println("EX 1")

for i in 1:maximum(result1)
    print("component $i : ")
    for j in findall(==(i), result1)
    print(j[2], " " )
    end    
    println()
end

println()

# EX 2
g_3 = SimpleDiGraph(7)
add_edge!(g_3, 1, 2)
add_edge!(g_3, 2, 4)
add_edge!(g_3, 2, 3)
add_edge!(g_3, 3, 4)
add_edge!(g_3, 3, 6)
add_edge!(g_3, 4, 1)
add_edge!(g_3, 4, 5)
add_edge!(g_3, 5, 6)
add_edge!(g_3, 6, 7)
add_edge!(g_3, 7, 5)

result3 = SCCA(g_3)

println("EX 2")

for i in 1:maximum(result3)
    print("component $i : ")
    for j in findall(==(i), result3)
    print(j[2], " " )
    end    
    println()
end

println()

# EX 3
g_4 = SimpleDiGraph(12, 20)

result4 = SCCA(g_4)

println("EX 3")

for i in 1:maximum(result4)
    print("component $i : ")
    for j in findall(==(i), result4)
    print(j[2], " " )
    end    
    println()
end