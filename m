Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbXE2WiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbXE2WiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbXE2WiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:38:13 -0400
Received: from www.osadl.org ([213.239.205.134]:59131 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750880AbXE2WiM (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:38:12 -0400
Subject: Re: [BUG] Something goes wrong with timer statistics.
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Ian Kumlien <iank@bredband.net>, Linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <6bffcb0e0705291524y2752d646p94b0bf6ca87af68f@mail.gmail.com>
References: <1180474738.22497.25.camel@pi.pomac.com>
	 <6bffcb0e0705291524y2752d646p94b0bf6ca87af68f@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 30 May 2007 00:38:08 +0200
Message-Id: <1180478288.20546.39.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 00:24 +0200, Michal Piotrowski wrote:
> Hi Ian,
> 
> (Thomas "The Wizard of Time" added to CC :))

Added more wizards :)

> On 29/05/07, Ian Kumlien <iank@bredband.net> wrote:
> > Hi,
> >
> > As the daystar sets, i try to play some with my new would be
> > firewall/server, but since this will be running for quite some time i
> > have been experimenting with powertop to find out what i can do to limit
> > it's power usage.
> >
> > But, if i run powertop for too long or a few times to many... this
> > happens:
> > http://pomac.netswarm.net/pics/kernel_panic.jpg

This was reported before. It's incredibly hard to reproduce.

Ian, is this happening reproducible ?

> > If i don't run powertop, it is rock solid... Compiling for hours,
> > running memtest for hours etc etc...
> 
> (Where is my magic ball?)
> 
> Let me guess - Pentium 4 with HT?

I might be wrong, but it's a newer core duo thingy.

	tglx


