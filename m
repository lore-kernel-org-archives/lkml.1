Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZHUNxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZHUNxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 09:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbZHUNxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 09:53:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbZHUNxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 09:53:23 -0400
Date: Fri, 21 Aug 2009 15:52:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, peterz@infradead.org, torvalds@linux-foundation.org,
       tytso@mit.edu, arjan@infradead.org, greg@kroah.com, mcgrof@gmail.com,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org, sam@ravnborg.org,
       corbet@lwn.net, sourcejedi.lkml@googlemail.com, andi@firstfloor.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: Re: [PATCH 00/14] kconfig: streamline distro configs for testers
Message-ID: <20090821135249.GB30346@elte.hu>
References: <20090819025634.987354707@goodmis.org> <20090820143025.7134930f.akpm@linux-foundation.org> <alpine.DEB.2.00.0908201741370.16405@gandalf.stny.rr.com> <20090820151326.b43038ce.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820151326.b43038ce.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 20 Aug 2009 17:43:38 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > 
> > > > The following patches are in:
> > > > 
> > > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > > > 
> > > >     branch: kconfig
> > > 
> > > Sam's been quiet lately.  I suggest that you add this to linux-next
> > > now so people get a chance to poke at it.
> > 
> > I have no means of pushing into next. Would someone like to do a pull for 
> > me?
> 
> If suitably bribed, Stephen will add you tree directly to the 
> linux-nxt lineup.

Yep, we always needed another kconfig maintainer (Sam's being mostly 
busy with kbuild), and it's nice to see that Steve volunteered for 
that job now! ;-)

	Ingo
