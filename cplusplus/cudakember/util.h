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

#ifndef util_h__
#define util_h__

#include <string>
#include <vector>
#include <iostream>

#define FOREACHj(i_, x) for(typeof((x).begin()) i_ = (x).begin(); i_ != (x).end(); ++i_)
#define FOREACH(x) FOREACHj(i, x)

class option_reader
{
public:
	enum { arg, optparam, flag };
	int nargs;

protected:
	struct io
	{
		int type; // this is either option_reader::arg,optparam or flag
		std::string name;

		io(int type_, const std::string &name_) : type(type_), name(name_) {}

		virtual std::istream  &read_val(std::istream &in) = 0;
		virtual std::ostream &write_val(std::ostream &out) const = 0;
	};

	template<typename T>
	struct io_spec : public io
	{
		T &var;
		io_spec(T &v, int type_, const std::string &name_) : var(v), io(type_, name_) {}

		virtual std::istream  &read_val(std::istream &in)  { return  in >> var; }
		virtual std::ostream &write_val(std::ostream &out) const { return out << var; }
	};

	std::vector<io*> params;

public:
	option_reader() : nargs(0) { }

	template<typename T> void add(const std::string &name, T &t, int type);
	bool process(int argc, char **argv);

	std::string cmdline_usage(const std::string &progname) const;
	std::string help() const;
	
	~option_reader();
};

template<typename T>
void option_reader::add(const std::string &name, T &t, int type)
{
	io_spec<T> *io = new io_spec<T>(t, type, name);
	params.push_back(io);

	if(type == arg) { nargs++; }
}

#endif
