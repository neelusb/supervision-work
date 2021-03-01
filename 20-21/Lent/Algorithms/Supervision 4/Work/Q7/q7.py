import math

# The worst case storage requirement of toexplore in the bfs() function in the
# lecture notes is Omega(V), or more precisely V-1 elements in the queue, in
# the situation where all vertices (except the start vertex) are neighbours of
# the start vertex.

# We can reduce the storage requirement to continue to use O(1) storage within
# each vertex object but O(1) extra memory but it comes at a cost of speed.
# In addition to the seen flag, we can also store a queue_position flag and an
# popped flag in each vertex, so the storage within each vertex object is still
# constant, and we will no longer have to use extra memory for the queue, but
# we can cycle through each vertex and visit the one with the lowest
# queue_position that hasn't already been popped until we are done. We will
# need to store the current first element in the queue, and a boolean storing
# whether we are done, which is O(1) extra storage as it is just these two
# flags regardless of how many vertices there are. Essentially what we are
# doing is replacing the explicit queue with flags within each vertex storing
# whether they have been popped and what their position in the queue is.


def bfs(g, s):
    for v in g.vertices:
        v.seen = False
        v.queue_position = math.inf
        v.popped = False
    s.seen = True
    s.queue_position = 0

    finished = False
    last_queue_position = 0

    while not finished:
        # First find the first element in the queue, i.e. smallest queue
        # position which hasn't already been popped.
        first_element = None
        finished = True
        for v in g.vertices:
            if first_element is None or \
                    (v.queue_position < first_element.queue_position and
                        not v.popped):
                first_element = v
            if v.seen and not v.popped:
                finished = False

        # We now have the vertex that is the first element in the queue, so we
        # investigate its neighbours as before
        first_element.popped = True
        for w in first_element.neighbours:
            if not w.seen:
                w.queue_position = last_queue_position
                # We increment the last queue position
                last_queue_position += 1
                w.seen = True
