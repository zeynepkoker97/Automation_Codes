import sys

print("dsDNA:")
print("selected_1   ------------------------    selected_1_prime")
print("selected_2   ------------------------    selected_2_prime\n")

print("Hairpin DNA:")
print("selected_1   ------------------------    selected_1_prime")
print("                                     |")
print("selected_2   ------------------------    selected_2_prime\n")

pdb_file = open(sys.argv[1] + ".pdb",'r')
contacts_atom = open('contacts_atom.txt','w')

go_Initial_Setup_start = 'selected_1'
go_Initial_Setup_End = 'selected_2_prime'
pdb_file_lines = pdb_file.readlines()[1:]

total_resid = 0
all_resname = []

AZW = False

for line in pdb_file_lines:
    line_splitted = line.split()
    if len(line_splitted) > 3:
        total_resid = int(line_splitted[5])
        if line_splitted[3] == 'AZW':
            AZW = True

selected_1 = 1
selected_1_prime = int(total_resid/2)

selected_2 = total_resid
selected_2_prime = int((total_resid/2)+1)

for line in pdb_file_lines:
    line_splitted = line.split()
    if len(line_splitted) > 3:
        if AZW == False :
            if line_splitted[5] == str(selected_1) and line_splitted[3][len(line_splitted[3])-1] == '5' and line_splitted[2] == 'O5\'':
                selected_1_atom = line_splitted[1]
                print("-----------------------------------")
                print("Atom Contact 1:")
                print("Serial Number:   ", selected_1_atom, "   Resid ID:  ", line_splitted[5])
                print("-----------------------------------")
            if line_splitted[5] == str(selected_1_prime) and line_splitted[3][len(line_splitted[3])-1] == '3' and line_splitted[2] == 'O3\'':
                selected_1_prime_atom = line_splitted[1]
                print("Atom Contact 1 Prime:")
                print("Serial Number:   ", selected_1_prime_atom, " Resid ID:  ", line_splitted[5])
                print("-----------------------------------")
            if line_splitted[5] == str(selected_2_prime) and line_splitted[3][len(line_splitted[3])-1] == '5' and line_splitted[2] == 'O5\'':
                selected_2_prime_atom = line_splitted[1]
                print("Atom Contact 2 Prime:")
                print("Serial Number:   ", selected_2_prime_atom, " Resid ID:  ", line_splitted[5])
                print("-----------------------------------")
            if line_splitted[5] == str(selected_2) and line_splitted[3][len(line_splitted[3])-1] == '3' and line_splitted[2] == 'O3\'':
                selected_2_atom = line_splitted[1]
                print("Atom Contact 2:")
                print("Serial Number:   ", selected_2_atom, "   Resid ID:  ", line_splitted[5])
                print("-----------------------------------")

        else:
            if line_splitted[5] == str(selected_1) and line_splitted[3][len(line_splitted[3])-1] == '5' and line_splitted[2] == 'O5\'':
                selected_1_atom = line_splitted[1]
                print("-----------------------------------")
                print("Atom Contact 1:")
                print("Serial Number:   ", selected_1_atom, "   Resid ID:  ", line_splitted[5])
                print("-----------------------------------")
            if line_splitted[5] == str(selected_1_prime+1) and line_splitted[3][len(line_splitted[3])-1] == 'W' and line_splitted[2] == 'OP1':
                selected_1_prime_atom = line_splitted[1]
                print("Atom Contact 1 Prime:")
                print("Serial Number:   ", selected_1_prime_atom, " Resid ID:  ", line_splitted[5])
                print("-----------------------------------")
            if line_splitted[5] == str(selected_2_prime+1) and line_splitted[2] == 'OP1':
                selected_2_prime_atom = line_splitted[1]
                print("Atom Contact 2 Prime:")
                print("Serial Number:   ", selected_2_prime_atom, " Resid ID:  ", line_splitted[5])
                print("-----------------------------------")
            if line_splitted[5] == str(selected_2) and line_splitted[3][len(line_splitted[3])-1] == '3' and line_splitted[2] == 'O3\'':
                selected_2_atom = line_splitted[1]
                print("Atom Contact 2:")
                print("Serial Number:   ", selected_2_atom, "   Resid ID:  ", line_splitted[5])
                print("-----------------------------------")
contacts_atom.write(str(selected_1_atom) + ' ' + str(selected_2_prime_atom))
pdb_file.close()
contacts_atom.close()
