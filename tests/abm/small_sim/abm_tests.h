#ifndef ABM_TESTS_H
#define ABM_TESTS_H

#include <iterator>
#include "../../../include/abm.h"
#include "../../../include/utils.h"
#include "../../common/test_utils.h"

template<typename T>
bool find_in_place(const std::vector<T>& places, const int aID, const int pID)
{
	const Place& place = places.at(pID-1);
	std::vector<int> agents = place.get_agent_IDs();
	if (std::find(agents.begin(), agents.end(), aID) != agents.end())
		return true;
	return false;
}

#endif
