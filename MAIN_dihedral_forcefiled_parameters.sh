#!/bin/bash

total_resid=23

first_parameters_list=( "1" "3" "5" "7" "9" )

force_constant_list=( " 0.000" "14.500" "50.000" )
force_constant_name_list=( "0-000" "14-500" "50-000" )

angle_list=( "  0.000" "180.000" )
angle_name_list=( "0-000" "180-000" )

last_list=( "0.000" "2.000" "4.000" )
last_name_list=( "0-000" "2-000" "4-000" )

length_first_parameters_list=${#first_parameters_list[@]}

length_force_constant_list=${#force_constant_list[@]}

length_angle_name_list=${#angle_name_list[@]}

length_last_list=${#last_name_list[@]}

for (( i=0; i<${length_first_parameters_list}; i++ ));
do
	for (( j=0; j<${length_force_constant_list}; j++ ));
	do
		for (( k=0; k<${length_angle_name_list}; k++ ));
		do
			for (( l=0; l<${length_last_list}; l++ ));
			do
			
				first_parameters=${first_parameters_list[$i]}
				
				force_constant=${force_constant_list[$j]}
				force_constant_name=${force_constant_name_list[$j]}
				
				angle=${angle_list[$k]}
				angle_name=${angle_name_list[$k]}
				
				last=${last_list[$l]}
				last_name=${last_name_list[$l]}
				
				mkdir Parameters_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}
				
				cp nuc_azw_optimized.pdb azw.prepin reimage.ptraj Parameters_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}

				cp tleap_merge.in Parameters_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}/tleap_merge_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.in 
	
				cp Hairpin_AZW_TURN.frcmod Parameters_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}/Hairpin_AZW_TURN_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.frcmod
				
				cp min1.in min2.in heat.in equal.in md_bas.in md.in Parameters_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}
				
				cp running_amber.sh Parameters_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}/running_amber_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.sh
				cp running_md.sh Parameters_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}/running_md_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.sh
				
				cd Parameters_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}
				
				sed -i 's/BBNNTT/'"$force_constant"'/g' Hairpin_AZW_TURN_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.frcmod
				sed -i 's/ZEYYNEP/'"$angle"'/g' Hairpin_AZW_TURN_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.frcmod
				sed -i 's/TTNBB/'"$last"'/g' Hairpin_AZW_TURN_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.frcmod
				sed -i 's/Z/'"$first_parameters"'/g' Hairpin_AZW_TURN_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.frcmod


				sed -i 's/ZEYYNEP/'${first_parameters}'_'${force_constant_name}'_'${angle_name}'_'${last_name}'/g' tleap_merge_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.in 

				FRCMOD_FILE=Hairpin_AZW_TURN_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.frcmod

				if [ -f "$FRCMOD_FILE" ]; then
					echo "$FRCMOD_FILE exists."
					xleap -f tleap_merge_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.in 
				else
					echo "$FRCMOD_FILE is MISSING!!!!"
				fi
				
				sed -i 's/ZEYNEP/'${total_resid}'/g' min1.in
				sed -i 's/ZEYNEP/'${total_resid}'/g' heat.in
				sed -i 's/ZEYNEP/'${total_resid}'/g' equal.in

				sed -i 's/ZEYYNEP/'${first_parameters}'_'${force_constant_name}'_'${angle_name}'_'${last_name}'/g' running_amber_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.sh

				bash running_amber_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.sh

				sed -i 's/ZEYYNEP/'${first_parameters}'_'${force_constant_name}'_'${angle_name}'_'${last_name}'/g' running_md_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.sh

				bash running_md_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.sh

				cpptraj -p system_water_${first_parameters}_${force_constant_name}_${angle_name}_${last_name}.prmtop -i reimage.ptraj
				
				cd ../
				
			done
		done
	done
done
	
	# vmd -parm7 system_water.prmtop -netcdf reimaged.nc


