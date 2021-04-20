#include "integration_tests.h"

/***************************************************** 
 *
 * Test suite for checking the contact counting 
 * functionality
 *
 * This does not cover the leisure locations
 *
 ******************************************************/

bool contacts_no_closures();
bool contacts_schools_closed();

// Supporting functions
ABM setup_simulations(double, std::string, int);

int main()
{
	test_pass(contacts_no_closures(), "Contacts count without closures");	
	test_pass(contacts_schools_closed(), "Contacts count with schools closed");
}

bool contacts_no_closures()
{
	// Model parameters
	double dt = 0.25;
	// Initially infected
	int infected_0 = 0;
	// File with infection parameters
	std::string pfname("test_data/infection_parameters_contacts_no_closures.txt");

	// Expected and computed average number of contacts
	double exp_ave_contacts = 139.6557375; 
	double ave_contacts = 0.0;

	ABM abm = setup_simulations(dt, pfname, infected_0);

	ave_contacts = abm.get_average_contacts();	

	if (!float_equality<double>(ave_contacts, exp_ave_contacts, 1e-2)){
		std::cerr << " Average number of computed contacts does not match expected " << std::endl;
		return false;
	}

	return true;
}

bool contacts_schools_closed()
{
	// Model parameters
	double dt = 0.25;
	// Initially infected
	int infected_0 = 0;
	// File with infection parameters
	std::string pfname("test_data/infection_parameters_contacts_closures.txt");

	// Expected and computed average number of contacts
	double exp_ave_contacts = 119.4382375; 
	double ave_contacts = 0.0;

	ABM abm = setup_simulations(dt, pfname, infected_0);

	ave_contacts = abm.get_average_contacts();	

	if (!float_equality<double>(ave_contacts, exp_ave_contacts, 1e-2)){
		std::cerr << "Average number of computed contacts does not match expected" << std::endl;
		return false;
	}

	return true;
}

// Initialize ABM simulations
ABM setup_simulations(double dt, std::string pfname, int inf_0)
{
	// Input files
	std::string fin("test_data/NR_agents.txt");
	std::string hfile("test_data/NR_households.txt");
	std::string sfile("test_data/NR_schools.txt");
	std::string wfile("test_data/NR_workplaces.txt");
	std::string hsp_file("test_data/NR_hospitals.txt");
	std::string rh_file("test_data/NR_retirement_homes.txt");
	std::string cp_file("test_data/NR_carpool.txt");
	std::string pt_file("test_data/NR_public.txt");
	std::string ls_file("test_data/NR_leisure.txt");

	// Files with age-dependent distributions
	std::string dexp_name("test_data/age_dist_exposed_never_sy.txt");
	std::string dh_name("test_data/age_dist_hospitalization.txt");
	std::string dhicu_name("test_data/age_dist_hosp_ICU.txt");
	std::string dmort_name("test_data/age_dist_mortality.txt");
	// Map for abm loading of distributions
	std::map<std::string, std::string> dfiles = 
		{ {"exposed never symptomatic", dexp_name}, {"hospitalization", dh_name}, 
		  {"ICU", dhicu_name}, {"mortality", dmort_name} };
	// File with 	
	std::string tfname("test_data/tests_with_time.txt");	

	ABM abm(dt, pfname, dfiles, tfname);

	// First the places
	abm.create_households(hfile);
	abm.create_schools(sfile);
	abm.create_workplaces(wfile);
	abm.create_hospitals(hsp_file);
	abm.create_retirement_homes(rh_file);
	abm.create_carpools(cp_file);
	abm.create_public_transit(pt_file);
	abm.create_leisure_locations(ls_file);

	abm.initialize_mobility();

	// Then the agents
	abm.create_agents(fin, inf_0);

	return abm;
}
