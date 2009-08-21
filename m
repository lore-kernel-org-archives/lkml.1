Return-Path: <linux-kernel-owner+w=401wt.eu-S932425AbZHUPIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbZHUPIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 11:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932364AbZHUPIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 11:08:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49017 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbZHUPIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 11:08:19 -0400
Date: Fri, 21 Aug 2009 11:08:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, peterz@infradead.org, torvalds@linux-foundation.org,
       tytso@mit.edu, arjan@infradead.org, greg@kroah.com, mcgrof@gmail.com,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org, sam@ravnborg.org,
       corbet@lwn.net, sourcejedi.lkml@googlemail.com, andi@firstfloor.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: Re: [PATCH 00/14] kconfig: streamline distro configs for testers
In-Reply-To: <20090821135249.GB30346@elte.hu>
Message-ID: <alpine.DEB.2.00.0908211106560.16405@gandalf.stny.rr.com>
References: <20090819025634.987354707@goodmis.org> <20090820143025.7134930f.akpm@linux-foundation.org> <alpine.DEB.2.00.0908201741370.16405@gandalf.stny.rr.com> <20090820151326.b43038ce.akpm@linux-foundation.org> <20090821135249.GB30346@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Aug 2009, Ingo Molnar wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 20 Aug 2009 17:43:38 -0400 (EDT)
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > > 
> > > > > The following patches are in:
> > > > > 
> > > > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > > > > 
> > > > >     branch: kconfig
> > > > 
> > > > Sam's been quiet lately.  I suggest that you add this to linux-next
> > > > now so people get a chance to poke at it.
> > > 
> > > I have no means of pushing into next. Would someone like to do a pull for 
> > > me?
> > 
> > If suitably bribed, Stephen will add you tree directly to the 
> > linux-nxt lineup.
> 
> Yep, we always needed another kconfig maintainer (Sam's being mostly 
> busy with kbuild), and it's nice to see that Steve volunteered for 
> that job now! ;-)

Sure why not?

I've created a new repo:

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-kconfig.git

and the same changes are in the branch: for-next

I still need to do the testing.

-- Steve

