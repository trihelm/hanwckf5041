/* Copyright (C) 1996,97,98,2002 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */

#include <features.h>
#include <netdb.h>
#undef h_errno

#include <tls.h>

/* We need to have the error status variable of the resolver
   accessible in the libc.  */
extern __thread int h_errno;


/* When threaded, h_errno may be a per-thread variable.  */
int *
__h_errno_location (void)
{
  return &h_errno;
}
