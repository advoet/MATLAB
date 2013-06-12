MATLAB
======

SUAMI 2013 Carnegie Mellon

Project Headed by Nick Leger
Authored by Alex Voet, Daniel Chupin, Jourdain Lamperski, Zack Greenberg

In this project we investigate various merging procedures for cells in voronoi diagrams.

Currently, our procedure is to choose two cells that share an edge, remove the points corresponding to those cells and
add an addition point corresponding to their midpoint. This is motivated by the process of condensation forming on a plate
where water droplets form and become larger by merging with droplets they touch. Our goal is to find an asympototic
self-similar function describing the changing distribution of the areas of cells (water droplets) at any given timestep.

Future research into the subject could consider probing different merging procedures for cells such as taking weighted
averages by area of cells being merged to determine a more accurate midpoint of merging. We could also consider having a
less randomized neighbor removal process i.e. selecting the closest neighbors of every pair, but more computational
efficiency/power would be necessary.
