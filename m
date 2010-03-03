Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab0CCVxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:53:30 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37083 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756707Ab0CCVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:53:25 -0500
Date: Wed, 3 Mar 2010 22:53:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-ID: <20100303215314.GC2579@ucw.cz>
References: <20100211195614.886724710@sbs-t61.sc.intel.com> <201002271323.14402.rjw@sisk.pl> <20100227124710.GA21164@elte.hu> <201002272007.43042.rjw@sisk.pl> <20100228072357.GB14205@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100228072357.GB14205@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Today's stats, done amongst users who are willing to opt in to the Smolt 
> daemon:
> 
>        x86: 99.7%
>    powerpc: 0.3%

Lies, bad lies, statistics.

> And yes, there are millions of ARM (and MIPS) CPUs running Linux as well. 
> (They are only as present as present their developers are: the users almost 
> never show up on linux-kernel.)

It cuts both ways. Maybe obscure architectures like alpha have more
than their marketshare of interested lkml users...

> Plus, a kernel subsystem maintainer like me who does lots of kernel 
> infrastructure work can have a pretty good gut feeling about which 
> architectures are actively helping out Linux, and which are just hanging on to 
> the bandwagon.

So instead of either fixing those architectures or marking them
deprecated, you blame Stephen for too much testing?

We are in middle of 'stable series', so regressions are not
permitted. You'd like to cause some regressions. Fine, but definitely
not Stephen's problem.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
