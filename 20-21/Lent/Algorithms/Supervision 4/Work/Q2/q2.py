def dfs_recurse_path(g, s, t):
    for v in g.vertices:
        v.visited = False
    path = []
    visit(s, t, path)
    return path


def visit(v, t, path):
    v.visited = True
    if t not in path:
        path.push(v)
    for w in v.neighbours:
        if not w.visited:
            visit(w, t, path)
