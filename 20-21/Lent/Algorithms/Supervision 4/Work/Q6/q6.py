import math


class Queue:
    # Just put this in so pylint doesn't give me errors
    pass


def bfs_path(g, s, t):
    for v in g.vertices:
        v.come_from = []
        v.distance = math.inf
    s.seen = True
    s.distance = 0
    toexplore = Queue([s])

    while not toexplore.is_empty():
        v = toexplore.popleft()
        for w in v.neighbours:
            if v.distance + 1 == w.distance:
                # If the current distance is the same as the distance through
                # this new path, we can simply append the current vertex to the
                # come_from list, and the distance does not change.
                w.come_from.append(v)
            elif v.distance + 1 < w.distance:
                # If the distance through this new path is less than the
                # current distance, we remove all vertices from the come_from
                # list as they are all further than this one, and just add
                # this vertex, and set the new distance.
                w.come_from = [v]
                w.distance = v.distance + 1
                if not w.seen:
                    # If we haven't seen this vertex yet, put it in the queue
                    toexplore.pushright(w)

            # If the current distance is less than the one through the new path
            # we don't care about the new path and just ignore it.

    if t.come_from == []:
        return None
    else:
        paths = [[t]]
        start_reached = (t == s)
        while not start_reached:
            new_paths = []
            for path in paths:
                for w in path.come_from:
                    new_paths.append([w] + path)
                    if w == s:
                        start_reached = True
            paths = new_paths
        return paths
