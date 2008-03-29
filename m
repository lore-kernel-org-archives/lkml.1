Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYC2Dmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYC2Dmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbYC2Dma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:42:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44544 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbYC2Dma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:42:30 -0400
Date: Sat, 29 Mar 2008 03:42:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] jbd/jbd2 NULL noise
Message-ID: <20080329034228.GK10722@ZenIV.linux.org.uk>
References: <E1JfRPa-0002U9-J5@ZenIV.linux.org.uk> <1206760526.6543.0.camel@brick> <20080329031843.GJ10722@ZenIV.linux.org.uk> <1206761196.6543.2.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206761196.6543.2.camel@brick>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 08:26:36PM -0700, Harvey Harrison wrote:
> On Sat, 2008-03-29 at 03:18 +0000, Al Viro wrote:
> > On Fri, Mar 28, 2008 at 08:15:26PM -0700, Harvey Harrison wrote:
> > > On Sat, 2008-03-29 at 03:07 +0000, Al Viro wrote:
> > > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > > ---
> > > >  fs/jbd/journal.c  |    4 ++--
> > > >  fs/jbd/revoke.c   |    4 ++--
> > > >  fs/jbd2/journal.c |   12 ++++++------
> > > >  fs/jbd2/revoke.c  |    4 ++--
> > > >  4 files changed, 12 insertions(+), 12 deletions(-)
> > > > 
> > > 
> > > I had just about all of fs/ done for this sitting in mm.
> > 
> > So send it?  I mean, that hardly has a potential to cause breakage - anything
> > wrong will be immediately seen on build.
> 
> I did, it went into -mm and on Mar 5 it was taken into the subsystem
> tree.

Wait a minute...  where had it been taken?  What subsystem tree for "just
about all of fs/"?  

In any case, if the stuff above is covered by whatever went to whichever
subsystem tree - by all means, discard that one.
