/***************************************************************************
 *   Copyright (C) 2008 by Mario Juric                                     *
 *   mjuric@ias.edu                                                        *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License, Version 2, as   *
 *   published by the Free Software Foundation.                            *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/

#include <iostream>
#include <sstream>

#include "util.h"

///// option_reader implementation
std::string option_reader::cmdline_usage(const std::string &progname) const
{
	std::stringstream ss;
	ss << progname << " " << help();
	return ss.str();
}

std::string option_reader::help() const
{
	std::ostringstream args, opts;
	FOREACH(params)
	{
		switch((*i)->type)
		{
		case arg:
			args << "<" << (*i)->name << "> ";
			break;
		case flag:
			args << "[--" << (*i)->name <<"] ";
			break;
		case optparam:
			opts << "[--" << (*i)->name << "="; (*i)->write_val(opts); opts << "] ";
			break;
		}
	}
	return opts.str() + args.str();
}

bool option_reader::process(int argc, char **argv)
{
	int iarg = 0;
	for(int i = 1; i != argc; i++)
	{
		std::string arg = argv[i];

		if(arg.find("--") == 0)
		{
			// process option
			bool opt_found = false;
			FOREACH(params)
			{
				if((*i)->type == flag && arg.substr(2) == (*i)->name)
				{
					std::string val = "1";
					std::istringstream ss(val);
					(*i)->read_val(ss);
					opt_found = true;
					break;
				}

				if((*i)->type == optparam)
				{
					std::string opt = (*i)->name + "=";
					if(arg.find(opt, 2) != 2) { continue; }

					std::string val = arg.substr(2+opt.size());
					std::istringstream ss(val);

					(*i)->read_val(ss);
					if(!ss)
					{
						std::cerr << "Error reading option --" << (*i)->name << ".\n";
						return false;
					}
					opt_found = true;
					break;
				}
			}
			
			if(!opt_found)
			{
				std::cerr << "Unknown option " << arg << ".\n";
				return false;
			}
		}
		else
		{
			// process argument
			iarg++;
			if(iarg > nargs)
			{
				std::cerr << "Error, too many arguments.\n";
				return false;
			}
			
			int k = 0;
			FOREACH(params)
			{
				if((*i)->type != option_reader::arg) { continue; }
				k++;
				if(k != iarg) { continue; }

				std::istringstream ss(arg);
				(*i)->read_val(ss);
				if(!ss)
				{
					std::cerr << "Error reading argument <" << (*i)->name << ">.\n";
					return false;
				}
				break;
			}
		}
	}

	if(iarg != nargs)
	{
		std::cerr << "Insufficient number of arguments (" << iarg << "/" << nargs << ").\n";
		return false;
	}
	
	return true;
}

option_reader::~option_reader()
{
	FOREACH(params)
	{
		delete *i;
	}
}
