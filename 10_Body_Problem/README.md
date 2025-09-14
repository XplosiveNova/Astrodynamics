# Class: Astrodynamics II

This Project is a simulation of a satellite being launched from LEO into a multi-planetary mission to Jupiter where it is then parked 30 Jupiter Radii away, taking into account the effect of gravity from: Earth, Moon, Sun, Mars, Jupiter, Io, Callisto, Europa, and Ganymede.

The program is split within three different segments A through C in order. Program A calculates and plots a porkchop plot of all possible trajectories since the launch window of January 1, 2031 using Time Dependent Lambert's Problem approach. An optimal Delta-V is then calculated which can be used as an input into Program B, which calculates a preliminary trajectory of the satellite using ODE45 integration. The rough data is then refined into Program C as a final trajectory of the satellite is calculated via BVP4C integration. Note that this program runs best with parallel processing.

The optimal delta-v of the mission was calculated to be 6.3 km/s with an elapsed mission time of ~ 808 JD's or 2.2 years. 

Figure: Porkchop Plot of Launch Window

<img width="1904" height="987" alt="Earth-Jupiter Lauch Window" src="https://github.com/user-attachments/assets/87241a79-7dbc-4205-9234-fbab567ab5b7" />

Figure: Total Trajectory of Satellite

<img width="1904" height="987" alt="Transfer to Jupiter (Final Solution)" src="https://github.com/user-attachments/assets/ad7d0295-b9af-435a-b036-4780d895058c" />

PERMISSION TO USE CODE:

Any use of the code within the "SourceCode" program folder, either in part or in full, must first be approved by Dr. Julio César Benavides, Founder and Curator of the Astronautical Engineering Archives (AEA). For permission to use this code, Dr. Benavides may be contacted at aea.engineer.com. Dr. Benavides currently works at The University of Texas at Arlington as a professor within Astrodynamics, Flight Dynamics, Spacecraft Systems Engineering, and much more. Even if the initial notation of explanation is not present, use of this code must be approved by Dr. Benavides.
