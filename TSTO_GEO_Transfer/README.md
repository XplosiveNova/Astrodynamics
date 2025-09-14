# Class: Astrodynamics II

This Project is a simulation of a satellite being launched via a Falcon 9 Block V launch vehicle to LEO, stay in orbit until it's able to complete a non-planar hohmann trasnfer, transfer to a target vehicle's orbit, complete a phazing maneuver to size the orbit to the target's position, then propagate said orbit for 24 hours. ODE45 was used to simulate the restricted 2-body problem of a satellite-earth system, where mutliple mission segments were designed to navigate the satellite to the desired location, while ODE45 was used to simulate the launch sequence of the Falcon 9 throughout the atmosphere, including MECO, SECO, jettison operations, and satellite send-off during its flight.

The program can be run via using the "MissionSimulation" file within "Mission". The simulation of the launch sequence is within "Launch" and is used to output the trajectory data of the rocket to then be inputted into the "MissionSimulation" program as an initial state.

The total delta-v of the mission was calculated to be 4.42 km/s with an elapsed mission time of ~ 1.8 JD's. 

Figure: Total Orbit of Satellite

<img width="888" height="659" alt="image" src="https://github.com/user-attachments/assets/e07e6f74-69d5-4359-ab43-1f835d80cfbb" />

Figure: Groundtrack of Satellite

<img width="1675" height="865" alt="image" src="https://github.com/user-attachments/assets/99087ddf-c835-472a-a481-3adaff07c6f1" />

PERMISSION TO USE CODE:

Any use of the code within the "Mission" or "Launch" program folders, either in part or in full, must first be approved by Dr. Julio César Benavides, Founder and Curator of the Astronautical Engineering Archives (AEA). For permission to use this code, Dr. Benavides may be contacted at aea.engineer.com. Dr. Benavides currently works at The University of Texas at Arlington as a professor within Astrodynamics, Flight Dynamics, Spacecraft Systems Engineering, and much more. Even if the initial notation of explanation is not present, use of this code must be approved by Dr. Benavides.
