This project is to create a brute-force optimization process to find the optimal shape and corresponding Lift-Drag ratio for a supersonic airfoil given the following constraints:

- Mach Number = 3.0
- Chord Length = 1 m
- Total Thickness >= 0.1m
- AOA = [0, 10] Degrees
- Cm = [-0.1, 0.1]
- Cl .= 0.3

Note that he process for calculating supersonic lift, drag, and pitching moment for a discrete airfoil was given as a .p code by Dr. Zhen Han. 

An optimal Lift-Drag Ratio was found to be ~3.31 at an AOA of 6 degrees, with similar shape to modern supersonic airfoil. A better optimization method can be designed for a large amount of variables, yet the project met guidelines and thus a brute-force method that lasts ~15 minutes was enough. More detail is explained within the design report (if you're willing to read 28 pages haha)
