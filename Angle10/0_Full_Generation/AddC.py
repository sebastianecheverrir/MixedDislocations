#!/home/sebastian/PythonEnvironments/EON35/bin/python

from ase.lattice.cubic 		import BodyCenteredCubic
from ase 			import Atom
from ase.io 			import write
from ase.io                     import read
from ase.calculators.lammpsrun 	import LAMMPS
from ase.optimize 		import BFGS
from ase.constraints 		import UnitCellFilter, ExpCellFilter

#genearating a system that contains bulk Fe with a single C interstitial

FeLatticeConstant = 2.8553122
#FeBulk = BodyCenteredCubic(directions=[[1,0,0], [0,1,0], [0,0,1]],
#                          size=(5,5,5), 
#                          symbol='Fe', 
#                          pbc=(1,1,1),
#                          latticeconstant=FeLatticeConstant)

FeBulk = read('data.Fe_mixed_Relaxed', format='lammps-data', style='atomic')

#Structureal minimisation for Fe bulk

#parameters = {'pair_style': 'eam/alloy',
#              'pair_coeff': ['* * FeC-Becquart2013.eam  Fe ']}
#
#files = ['FeC-Becquart2013.eam']
#
#FeBulk.calc = LAMMPS(files=files)
#FeBulk.calc.set(**parameters)
#
#minimisation = BFGS(FeBulk)
#minimisation.run(fmax=0.00005)

#adding a C atom

Csingle =  Atom('C', position=(FeLatticeConstant/2, FeLatticeConstant/2, 0))

FeBulk_C = FeBulk + Csingle

write('data.FeC_mixed_UnRelaxed',  FeBulk_C, 'lammps-data')


#doing a structural minimization 
#(Remember you also need to set the environment variable $ASE_LAMMPSRUN_COMMAND)

#parameters = {'pair_style': 'eam/alloy',
#              'pair_coeff': ['* * FeC-Becquart2013.eam C Fe ']}
#
#files = ['FeC-Becquart2013.eam']
#
#FeBulk_C.calc = LAMMPS(files=files)
#FeBulk_C.calc.set(**parameters)
#
#minimisation = BFGS(FeBulk_C)
#minimisation.run(fmax=0.00005)
#
#write('data.PositionFileForLammpsRelaxed',  FeBulk_C, 'lammps-data')
#write('data.PositionFileForEonRelaxed',  FeBulk_C, 'eon')
#
#
#
##print("Energy ", FeBulk_C.get_potential_energy())
#
#
#
#
