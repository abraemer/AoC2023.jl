module Dijkstra

export dijkstra

using DataStructures

dijkstra(neighbours::Function, target::NT, start::NT, heuristic=x->0, path=false) where NT = dijkstra(neighbours, ==(target), start, heuristic, path)

"""
   dijkstra(neighbours, targetp, start)

neighbours - function: node -> [(dist, node)...]
targetp - function: node -> Bool
start - starting point
"""
function dijkstra(neighbours::Function, targetp::Function, start, heuristic=x->0, path=false)
    initial_neighbours = neighbours(start)
    disttype, nodetype = typeof.(first(initial_neighbours))
    openqueue = PriorityQueue{nodetype, disttype}()
    for (dist, node) in initial_neighbours
        enqueue!(openqueue, node, dist)
    end
    seen = Set{nodetype}(Ref(start))
    if !path
        return _dijkstra(neighbours, targetp, heuristic, seen, openqueue)
    else
        priors = Dict([Pair(n, start) for (_, n) in initial_neighbours])
        return _dijkstra_path(neighbours, targetp, heuristic, seen, openqueue, priors)
    end
end

function _dijkstra(neighbours, targetp, heuristic, seen, openqueue)
    while true
        node, distance = dequeue_pair!(openqueue)
        targetp(node) && return distance
        push!(seen, node)
        old_heuristic = heuristic(node)
        for (δdist, neighbour) in neighbours(node)
            in(neighbour, seen) && continue
            new_dist = distance+δdist+heuristic(neighbour)-old_heuristic
            if !haskey(openqueue, neighbour)
                enqueue!(openqueue, neighbour, new_dist)
            else
                openqueue[neighbour] = min(new_dist, openqueue[neighbour])
            end
        end
    end
end

function _dijkstra_path(neighbours, targetp, heuristic, seen, openqueue, priors)
    while true
        node, distance = dequeue_pair!(openqueue)
        targetp(node) && return distance, _reconstruct_path(priors, node)
        push!(seen, node)
        old_heuristic = heuristic(node)
        for (δdist, neighbour) in neighbours(node)
            in(neighbour, seen) && continue
            new_dist = distance+δdist+heuristic(neighbour)-old_heuristic
            if !haskey(openqueue, neighbour)
                enqueue!(openqueue, neighbour, new_dist)
                priors[neighbour] = node
            elseif openqueue[neighbour] > new_dist
                openqueue[neighbour] = new_dist
                priors[neighbour] = node
            end
        end
    end
end

function _reconstruct_path(priors, target)
    path = [target]
    while haskey(priors, path[end])
        push!(path, priors[path[end]])
    end
    return reverse!(path)
end

function _next! end
_next!(q::PriorityQueue) = dequeue_pair!(q)

function _enqueue! end
_enqueue!(q::PriorityQueue, item, prio) = DataStructures.enqueue!(q, item, prio)

function _in end
_in(structure, elem) = Base.in(elem, structure)
_in(d::Dict, elem) = haskey(d, elem)

function _push! end
_push!(structure, elem) = push!(structure, elem)

function _add! end
_add!(structure, elem) = push!(structure, elem)

function _astar!(neighbours, targetp, heuristic, nodekey, nodedata, openqueue)
    while true
        nodeval, (node, distance, previous) = _next!(openqueue)
        targetp(node) && return distance
        _push!(seen, nodeval)
        for (δdist, neighbour) in neighbours(node)
            key = nodekey(neighbour)
            in(key, seen) && continue
            new_dist = distance+δdist
            new_prio = new_dist+heuristic(neighbour)
            _enqueue!(openqueue, nodeval, min(_get(openqueue, nodeval, )))
            if !haskey(openqueue, key)
                enqueue!(openqueue, (neighbour, distance+δdist), )
            else
                openqueue[key] = min(new_dist, openqueue[key])
            end
        end
    end
end

function astar(neighbours, heuristic, target, start)

end

## Notes
# - abstract saving seen nodes (if one f.e. want to store it in a destructive manner)
# - optional: return path to target (-> switch seen to mapping node -> previous)
# - introduce optional mapping node -> value to use as key

end #module
