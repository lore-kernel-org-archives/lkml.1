Return-Path: <linux-kernel-owner+w=401wt.eu-S934557AbZJIV60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934557AbZJIV60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934392AbZJIV6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:58:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934219AbZJIV6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:58:24 -0400
Date: Fri, 9 Oct 2009 14:57:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg KH <gregkh@suse.de>, Felipe Contreras <felipe.contreras@gmail.com>,
       Tony Lindgren <tony@atomide.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
       Madhusudhan Chikkature <madhu.cr@ti.com>
Subject: Re: [GIT PULL] omap fixes for v2.6.32-rc3
Message-Id: <20091009145724.24614ccd.akpm@linux-foundation.org>
In-Reply-To: <alpine.LRH.2.00.0910092336280.12171@twin.jikos.cz>
References: <20091007185112.GJ7899@atomide.com>
	<94a0d4530910081429m7ad88b43q38245109f3252078@mail.gmail.com>
	<20091008214140.GJ7417@atomide.com>
	<94a0d4530910081513w1a919dc2s50eca41966a2261d@mail.gmail.com>
	<94a0d4530910081520t66ce7567xe142979a35b1245@mail.gmail.com>
	<20091008232603.GB25892@atomide.com>
	<94a0d4530910090508o1e3d19cew881d2eb348199674@mail.gmail.com>
	<20091009144840.GA9561@suse.de>
	<94a0d4530910091029p12f8c28fve91e95db533e78e5@mail.gmail.com>
	<20091009192642.GB32084@suse.de>
	<alpine.LRH.2.00.0910092336280.12171@twin.jikos.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009 23:42:27 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Fri, 9 Oct 2009, Greg KH wrote:
> 
> > > >> There's a tree for trivial fixes:
> > > >> git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
> 
> Well, as this is quite a high-priority functional fix, I'd suggest using 
> other channels that trivial tree, as this one is primarily intended for 
> simple fixes that are not really urgent.
> 
> > > The problem is that OMAP devices (like beagleboard) are not booting 
> > > correctly right now because of a wrong merge. It has been identified, 
> > > tested, and acked, but nobody has picked it up for a pull request, so 
> > > it's not clear it will be on -rc4.
> > Has the patches been sent from the maintainer to Linus?
> > Who is the maintainer?  Who normally sends this stuff?
> 
> The problem is that MMC now doesn't have proper maintainer, since Pierre 
> stepped down from maintaining this stuff.
> 
> Still, for the fix mentioned on
> 
> 	http://www.mail-archive.com/linux-mmc@vger.kernel.org/msg00539.html
> 
> the most appropriate contact would probably be Madhusudhan Chikkature. 
> Adding him to CC of this thread.

hm.  What's all the fuss about?  That patch was sent To:me and affects
only MMC and is clearly a bugfix.  I'll merge it when i get to it
(hopefully tomorrow) then all is good?

