/*
Copyright 2015 Johan Gunnarsson <johan.gunnarsson@gmail.com>

This file is part of BTFS.

BTFS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

BTFS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with BTFS.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef BTFS_H
#define BTFS_H

#include <vector>
#include <list>
#include <fstream>

#include <pthread.h>
#include <thread>

#include "libtorrent/config.hpp"
#include <libtorrent/peer_request.hpp>

#include "livebtfsstat.h"

namespace btfs
{

class Part;
class Read;

enum type_state { empty, asked, filled };

class Part
{
	friend class Read;

public:
	Part(lt::peer_request p, char *b) : part(p), buf(b)
	{
	}

private:
	lt::peer_request part;

	char *buf;

	char state = empty;
};

class Read
{
public:
	Read(char *buf, int index, off_t offset, size_t size);

	void fail(int piece);

	void copy(int piece, char *buffer);

	void trigger();

	bool seek_to_ask (int numPiece, bool& read_piece_after);
	void verify_to_ask (int numPiece);

	bool finished();
	void isFinished();

	int read();

private:
	bool failed = false;

	int size=0;
	int nbPieceNotFilled=0;

	pthread_mutex_t waitFinished = PTHREAD_MUTEX_INITIALIZER;

	std::vector<Part> parts;
};

class Array
{
public:
	Array() : buf(0), size(0) {
	}

	~Array() {
		free(buf);
	}

	bool expand(size_t n) {
		char* new_buf = (char *) realloc((void *) buf, size += n);
		if( new_buf != NULL )
		{
			buf = new_buf;
			return true;
		}
		return false;
	}

	char *buf;

	size_t size;
};

struct btfs_params {
	int version;
	int help;
	int help_fuse;
	int browse_only;
	int keep;
	int utp_only;
	char *data_directory;
	int min_port;
	int max_port;
	int max_download_rate;
	int max_upload_rate;
	const char *metadata;
	int disable_dht;
	int disable_upnp;
	int disable_natpmp;
	int disable_lsd;
	int disable_all;
};

}

#endif
