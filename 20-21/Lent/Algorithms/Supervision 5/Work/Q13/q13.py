# Question 13

def bfs_seen(graph, start):
    # run breadth first search, and then:
    return [v for v in graph.vertices if v.seen]


def is_dag(graph):
    seen_from = {}
    for v in graph:
        seen = bfs_seen(graph, v)  # A list of vertices reachable from v
        seen_from[v] = seen
        for w in seen:
            if w in seen_from:  # if w already explored
                if v in seen_from[w]:  # if v reachable from w
                    # We know w is reachable from v. If v is also reachable
                    # from w then there must be a cycle between v and w
                    return False
    # ASSERT: No cycles exist, as they would have been caught in the loop above
    return True
