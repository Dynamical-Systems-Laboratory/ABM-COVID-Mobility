#include "../../include/places/leisure.h"

/***************************************************** 
 * class: Leisure 
 * 
 * Defines and stores attributes of a single leisure 
 * location 
 * 
 *****************************************************/

//
// I/O
//

// Save information about a Workplace object
void Leisure::print_basic(std::ostream& where) const
{
	Place::print_basic(where);
	where << " " << type;	
}


