Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYBQXOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYBQXOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 18:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbYBQXON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 18:14:13 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51627 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbYBQXOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 18:14:12 -0500
Date: Mon, 18 Feb 2008 01:13:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Message-ID: <20080217231343.GM1403@cs181133002.pp.htv.fi>
References: <200802172304.00322.rjw@sisk.pl> <Pine.LNX.4.64.0802172342431.7699@twin.jikos.cz> <200802180006.41880.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200802180006.41880.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 12:06:41AM +0100, Rafael J. Wysocki wrote:
> On Sunday, 17 of February 2008, Jiri Kosina wrote:
> > On Sun, 17 Feb 2008, Rafael J. Wysocki wrote:
> > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9842
> > > Subject		: key 49 and 94 send both 49 and 94 events on macbooks REGRESSION
> > > Submitter	: Emil Karlson <jkarlson@cc.hut.fi>
> > > Date		: 2008-01-29 08:15
> > 
> > I have already fixed this one, and fix has been already picked by Linus 
> > from my tree, so you can drop this one. (even the bugzilla is closed 
> > properly).
> 
> Hmm, the script should have noticed that.  I'll need to figure out why it didn't.

It was marked as resolved, not as closed.

>...
> > > Please let me know if there are any Bugzilla entries that should be added to
> > > the list in there.
> > 
> > Thanks a lot Rafael for this regression tracking.
> > 
> > BTW I think it might still be useful to CC everyone involved on these 
> > reports, even though the bugzillas probably have the correct addressess 
> > already.
> 
> Hm, I'd rather avoid sending messages with 100+ addresses in the CC list. :-)
>...

The main problem is vger dropping emails with >= 30 recipients...

> Thanks,
> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

