#
# Script for counting average contact number based on the input
#

# Contacts at every location 
households = []
ret_homes = []
schools = []
workplaces = []
hospitals = []

# Hardcoded contact limits
max_rh =  40
max_sch = 50
max_hsp = 30
max_wrk = 20

# Read and initialize
with open('test_data/NR_households.txt', 'r') as fin:
	nloc = len(fin.readlines())
	households = [0]*nloc

with open('test_data/NR_retirement_homes.txt', 'r') as fin:
	nloc = len(fin.readlines())
	ret_homes = [0]*nloc

with open('test_data/NR_schools.txt', 'r') as fin:
	nloc = len(fin.readlines())
	schools = [0]*nloc

with open('test_data/NR_workplaces.txt', 'r') as fin:
	nloc = len(fin.readlines())
	workplaces = [0]*nloc

with open('test_data/NR_hospitals.txt', 'r') as fin:
	nloc = len(fin.readlines())
	hospitals = [0]*nloc

with open('test_data/NR_carpool.txt', 'r') as fin:
	nloc = len(fin.readlines())
	carpools = [0]*nloc

with open('test_data/NR_public.txt', 'r') as fin:
	nloc = len(fin.readlines())
	public_transit = [0]*nloc

# Count agents in each place
with open('test_data/NR_agents.txt', 'r') as fin:
	for line in fin:
		temp = line.strip().split()
		# Hospital patient
		if temp[6] == '1':
			hospitals[int(temp[13])-1] += 1
			continue
		# Retirement home resident
		if temp[8] == '1':
			ret_homes[int(temp[5])-1] += 1
			continue
		households[int(temp[5])-1] += 1

		# Student
		if temp[0] == '1':
			schools[int(temp[7])-1] += 1
		
		# Carpools
		if temp[17] == 'carpool':
			carpools[int(temp[19])-1] += 1
		# Public transit 
		if temp[17] == 'public':
			public_transit[int(temp[20])-1] += 1
	
		# Hospital employee
		if temp[12] == '1':
			hospitals[int(temp[13])-1] += 1
			continue

		# Retirement home empoyee
		if temp[9] == '1':
			ret_homes[int(temp[18])-1] += 1
			continue
		# School employee
		if temp[10] == '1':
			schools[int(temp[18])-1] += 1
			continue
		# Generic workplace	
		if temp[1] == '1' and temp[15] != '1':
			workplaces[int(temp[11])-1] += 1
			continue

# Count contacts of each agent
nc_tot = 0
nc_tot_ns = 0
n_agnt_tot = 0
with open('test_data/NR_agents.txt', 'r') as fin:
	for line in fin:
		temp = line.strip().split()
		n_agnt_tot += 1 
		# Hospital patient
		if temp[6] == '1':
			nc_tot += min(hospitals[int(temp[13])-1], max_hsp)
			nc_tot_ns += min(hospitals[int(temp[13])-1], max_hsp)
			continue
		# Retirement home resident
		if temp[8] == '1':
			nc_tot += min(ret_homes[int(temp[5])-1], max_rh)
			nc_tot_ns += min(ret_homes[int(temp[5])-1], max_rh)
			continue
		nc_tot += households[int(temp[5])-1]
		nc_tot_ns += households[int(temp[5])-1]
		
		# Student
		if temp[0] == '1':
			nc_tot += min(schools[int(temp[7])-1], max_sch)

		# Transit
		# Carpools
		if temp[17] == 'carpool':
			nc_tot += carpools[int(temp[19])-1]
			nc_tot_ns += carpools[int(temp[19])-1]
		# Public transit 
		if temp[17] == 'public':
			nc_tot += public_transit[int(temp[20])-1]
			nc_tot_ns += public_transit[int(temp[20])-1]

		# Hospital employee
		if temp[12] == '1':
			nc_tot += min(hospitals[int(temp[13])-1], max_hsp)
			nc_tot_ns += min(hospitals[int(temp[13])-1], max_hsp)
			continue

		# Retirement home empoyee
		if temp[9] == '1':
			nc_tot += min(ret_homes[int(temp[18])-1], max_rh)
			nc_tot_ns += min(ret_homes[int(temp[18])-1], max_rh)
			continue
		# School employee
		if temp[10] == '1':
			nc_tot += min(schools[int(temp[18])-1], max_sch)
			continue
		# Generic workplace	
		if temp[1] == '1':
			# Works from home
			if temp[15] == '1':
				continue
			nc_tot += min(workplaces[int(temp[11])-1], max_wrk)
			nc_tot_ns += min(workplaces[int(temp[11])-1], max_wrk)
			continue

n_ave = nc_tot/n_agnt_tot
n_ave_closures = nc_tot_ns/n_agnt_tot

print('Schools open', n_ave)
print('Schools closed', n_ave_closures)




