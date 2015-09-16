#ifndef PERSIANSHAPING_H
#define PERSIANSHAPING_H

/*
 *      Copyright (C) 2005-2008 Team XBMC
 *      http://www.xbmc.org
 *
 *  A port of Mohammed Yousif's C Arabic shaping code
 *  Ported by Nibras Al-shaiba
 *	Persian version by Ali Nadalizadeh
 *
 *  This Program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2, or (at your option)
 *  any later version.
 *
 *  This Program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with XBMC; see the file COPYING.  If not, write to
 *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
 *  http://www.gnu.org/copyleft/gpl.html
 *
 */

//#include "fribidi.h"
typedef unsigned short FriBidiChar;
typedef int fribidi_boolean;

/**
 * Shapes an Arabic text chunk
 *
 * @param FriBidiChar * (The Arabic text chunk to be shaped in Unicode)
 * @return FriBidiChar * (The shaped Arabic text chunk in Unicode, the user is resposible for freeing it)
 */
FriBidiChar * shape_arabic(FriBidiChar *, int);

#endif /* PERSIANSHAPING_H */
