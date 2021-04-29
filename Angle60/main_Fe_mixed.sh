#!/bin/bash

############################################################

#Script to generate a quadrupole of
#    mixed 60.5 dislocations

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
#    mixed 60.5 dislocations

#the crystal is oriented in the following direction
#         x            y             z 
#    [-1, 3, -1]  [-1, 0, 1]     [3, 2, 3]     60.503792

#the dislocation line points towards
#        z
#     [3, 2, 3]

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

atomsk --create bcc 2.8553122 Fe orient  [-13-1]  [-101]     [323] \
-duplicate 20 20 1 \
-prop elastic.txt \
-disloc 0.501*box 0.251*box mixed z y 2.152273 0.0 -1.217509 \
-disloc 0.501*box 0.751*box mixed z y 2.152273 0.0 -1.217509 \
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


