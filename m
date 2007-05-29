Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbXE2Wvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbXE2Wvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXE2Wv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:51:27 -0400
Received: from mxfep01.bredband.com ([195.54.107.70]:52392 "EHLO
	mxfep01.bredband.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbXE2Wv0 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:51:26 -0400
Subject: Re: [BUG] Something goes wrong with timer statistics.
From: Ian Kumlien <iank@bredband.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1180478288.20546.39.camel@chaos>
References: <1180474738.22497.25.camel@pi.pomac.com>
	 <6bffcb0e0705291524y2752d646p94b0bf6ca87af68f@mail.gmail.com>
	 <1180478288.20546.39.camel@chaos>
Content-Type: text/plain
Date: Wed, 30 May 2007 00:50:55 +0200
Message-Id: <1180479065.19814.6.camel@pi.pomac.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On ons, 2007-05-30 at 00:38 +0200, Thomas Gleixner wrote:
> On Wed, 2007-05-30 at 00:24 +0200, Michal Piotrowski wrote:
> > Hi Ian,
> > 
> > (Thomas "The Wizard of Time" added to CC :))
> 
> Added more wizards :)
> 
> > On 29/05/07, Ian Kumlien <iank@bredband.net> wrote:
> > > Hi,
> > >
> > > As the daystar sets, i try to play some with my new would be
> > > firewall/server, but since this will be running for quite some time i
> > > have been experimenting with powertop to find out what i can do to limit
> > > it's power usage.
> > >
> > > But, if i run powertop for too long or a few times to many... this
> > > happens:
> > > http://pomac.netswarm.net/pics/kernel_panic.jpg
> 
> This was reported before. It's incredibly hard to reproduce.
> 
> Ian, is this happening reproducible ?

Seems like it, i haven't actually TRIED to crash yet... 
But i can try if i don't have to crash in the future =)

(The machine is just a motherboard lying on the floor with some disks
attached, so i have to bring out my pocket knife and short circuit the
right pins =))

> > > If i don't run powertop, it is rock solid... Compiling for hours,
> > > running memtest for hours etc etc...
> > 
> > (Where is my magic ball?)
> > 
> > Let me guess - Pentium 4 with HT?
> 
> I might be wrong, but it's a newer core duo thingy.
> 
> 	tglx
> 
-- 
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net
