# PN Guidance Interceptor Simulation — MATLAB & Simulink

This is my first GitHub project, built around a MATLAB/Simulink simulation of a nonlinear 6-DOF interceptor model using proportional navigation (PN) guidance.

I put this together mainly to understand how the different parts of a guidance and flight-dynamics simulation fit together instead of treating the model as one big block.

## What is included

The model is built from a few main pieces:

- Target motion model
- 12-state nonlinear 6-DOF equations of motion
- NED position and velocity conversion
- True proportional navigation guidance
- Autopilot with dynamic-pressure-based gain scheduling
- Second-order pitch and yaw actuator models
- Simple aerodynamic force and moment model
- Miss-distance calculation
- Basic interception detection
- MATLAB workspace logging for positions and velocities

## Main file

`build_6dof_interceptor.m` is the main script. Running it in MATLAB creates the `Interceptor6DOF` Simulink model, connects the blocks, sets the solver configuration, and saves the model as `Interceptor6DOF.slx` in the current MATLAB folder.

The script was written around modern MATLAB/Simulink APIs and is intended to be used with MATLAB releases around R2021b or newer.

## Model notes

The simulation uses the NED (North-East-Down) frame for the inertial position and target geometry, with body-axis states for the vehicle dynamics.

The aerodynamic, mass, inertia, thrust, and target values in this project are **generic illustrative values**. They are not intended to represent a real missile or real-world weapon system. The purpose of the model is educational simulation and control-system study.

## Getting started

1. Open MATLAB.
2. Put `build_6dof_interceptor.m` in your working folder.
3. Run the script.
4. Open the generated `Interceptor6DOF.slx` model.
5. Run the Simulink simulation.
6. Check the miss-distance scope and the logged workspace variables.

The script also prints the generated model name and a `sim('Interceptor6DOF')` command at the end.

## What I want to improve

This is a starting point rather than a finished flight-dynamics model. Some things I would like to improve later are better aerodynamic data, more realistic propulsion, additional validation cases, and a cleaner set of plots for analyzing guidance performance.

## Disclaimer

This repository is for academic/educational simulation work. The parameters are intentionally generic and illustrative, and the model should not be treated as a real-world weapon design or engineering specification.
