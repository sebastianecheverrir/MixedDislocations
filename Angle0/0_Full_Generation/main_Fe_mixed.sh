#!/bin/bash

############################################################

#Script to generate a quadrupole of
#    mixed 0 dislocations

############################################################

#28-04-2021
#Sebastian Echeverri Restrepo
#sebastianecheverrir@gmail.com

############################################################

#Software needed
#    Lammps   https://lammps.sandia.gov/
#    Atomsk   https://atomsk.univ-lille.fr/
#    Python
#    ASE      https://wiki.fysik.dtu.dk/ase/

############################################################

#Dislocation type
#    mixed 0 dislocations

#the crystal is oriented in the following direction
#         x            y             z 
#     [1, 2, 1]   [-1, 0, 1]    [1, -1, 1]  0.000000

#the dislocation line points towards
#        z
#    [1, -1, 1]

#The glide plane is 
#        y
#    [-1, 0, 1]

############################################################

#We use a lattice parameter of 2.8553122, as predicted by 
#    the interatomic potential
#    10.1016/j.commatsci.2013.09.048

############################################################

rm log.lammps data.FeC_mixed_UnRelaxed data.Fe_mixed_Relaxed Fe_mixed.lmp data.FeC_mixed_Relaxed dump.Fe_mixed_Relaxed

############################################################
#Using atomsk to generate the unrelaxed quadrupole

atomsk --create bcc 2.8553122 Fe orient  [121]   [-101]    [1-11] \
-duplicate 8 8 3 \
-prop elastic.txt \
-disloc 0.251*box 0.251*box mixed z y 0.0 0.0 -2.472773 \
-disloc 0.251*box 0.751*box mixed z y 0.0 0.0 2.472773 \
-disloc 0.751*box 0.251*box mixed z y 0.0 0.0 2.472773 \
-disloc 0.751*box 0.751*box mixed z y 0.0 0.0 -2.472773 \
Fe_mixed.lmp

############################################################
#relaxing the quadrupole 

module load lammps/intel/11Aug2017
mpirun -np 20 lmp_mpi < in.SystemRelaxation1

############################################################
#adding a single C atom with python and ASE

module load python/3.7.6
python3 AddC.py

############################################################
#relaxing the quadrupole with C using lammps (no box relaxation)
mpirun -np 20 lmp_mpi < in.SystemRelaxation2


rm log.lammps data.FeC_mixed_UnRelaxed data.Fe_mixed_Relaxed Fe_mixed.lmp 


