Return-Path: <linux-kernel-owner+w=401wt.eu-S936501AbXHMVO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936501AbXHMVO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764361AbXHMVNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:13:01 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3719 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765952AbXHMVNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:13:00 -0400
Subject: Re: [PATCH] [438/2many] MAINTAINERS - SLAB ALLOCATOR
From: Joe Perches <joe@perches.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: torvalds@linux-foundation.org, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0708131345130.27728@schroedinger.engr.sgi.com>
References: <46bffbc9.9Jtz7kOTKn1mqlkq%joe@perches.com>
	 <Pine.LNX.4.64.0708131345130.27728@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 14:12:37 -0700
Message-Id: <1187039557.10249.312.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 13:46 -0700, Christoph Lameter wrote:
> On Sun, 12 Aug 2007, joe@perches.com wrote:
> 
> > Add file pattern to MAINTAINER entry
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index b2dd6f5..a3c6123 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -4168,6 +4168,8 @@ P:	Pekka Enberg
> >  M:	penberg@cs.helsinki.fi
> >  L:	linux-mm@kvack.org
> >  S:	Maintained
> > +F:	include/linux/slab*
> 
> Use include/linux/sl?b*.h 
> 
> > +F:	mm/slab.c
> 
> Use mm/sl?b.c ?
> 
> Otherwise this does not include slub f.e.

Do you want slob too?

SLAB/SLUB ALLOCATOR
P:	Christoph Lameter
M:	clameter@sgi.com
P:	Pekka Enberg
M:	penberg@cs.helsinki.fi
L:	linux-mm@kvack.org
S:	Maintained
F:	include/linux/slab*.h
F:	include/linux/slub*.h
F:	mm/slab.c
F:	mm/slub.c

otherwise:

SLAB/SLUB ALLOCATOR
P:	Christoph Lameter
M:	clameter@sgi.com
P:	Pekka Enberg
M:	penberg@cs.helsinki.fi
L:	linux-mm@kvack.org
S:	Maintained
F:	include/linux/sl?b*.h
F:	mm/sl?b.c


