Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbYBVFD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbYBVFD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 00:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbYBVFDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 00:03:51 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33296 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbYBVFDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 00:03:50 -0500
Date: Fri, 22 Feb 2008 10:33:39 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de,
       arjan@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, sam@ravnborg.org
Subject: Re: [GIT PULL?] Create and populate toplevel tests/ for kernel
	tests
Message-ID: <20080222050339.GB6716@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20080211104452.GB7944@in.ibm.com> <20080212164452.GA31096@infradead.org> <20080212132246.aac67ed1.akpm@linux-foundation.org> <20080212223918.GA3927@uranus.ravnborg.org> <20080219192153.GA11948@uranus.ravnborg.org> <20080222034231.GA6716@in.ibm.com> <20080222155713.0304dd19.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222155713.0304dd19.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 03:57:13PM +1100, Stephen Rothwell wrote:
> Hi Ananth,
> 
> On Fri, 22 Feb 2008 09:12:31 +0530 Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> >
> > The patchset in question is just a major code movement - basically to
> > move all in-kernel tests to live under a toplevel tests/ directory. As
> > such, all the stakeholders have acked the patchset, but it does look
> > like this is a big enough change to be deferred to the next merge
> > window.
> > 
> > Given that there is general agreement about the patchset, could you
> > please pull in the changes into the linux-next tree?
> > 
> > Sam has setup a git tree for this and you can pull from:
> > ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/tests.git
> >  
> > Link to the thread: http://lkml.org/lkml/2008/2/11/97
> 
> I will include this in the next linux-tree.  It looks like it should not
> cause to many problems (it merges OK on top of the about to be announce
> next-20080222), but if I get a hard to resolve merge problem with it, I
> will drop it first, OK.
> 
> I have noted you as the contact.

Sure! Thanks Stephen.

Ananth
