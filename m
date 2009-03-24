Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZCXVHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZCXVHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZCXVHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:07:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51621 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZCXVHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:07:20 -0400
Date: Tue, 24 Mar 2009 22:07:15 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>
Subject: Re: [Announce] 2.6.29-rc8-rt3
Message-ID: <20090324210715.GA10130@pengutronix.de>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain> <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain> <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain> <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain> <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain> <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain> <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain> <20090324110431.GA6058@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090324110431.GA6058@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >     http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc8.tar.bz2
> >     http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc8-rt3.bz2
> 
> 
> Hi,
> 
> It doesn't seem to be available (404).
> But I can see a 2.6.29-rc8-rt4.bz2 downloadable.
> 
> Thanks.
This is a channel log from #linux-rt

19:57 < clark|w> tglx, just how small was the -rt3 window (which I hit btw)?
19:58 < tglx> you mean how long -rt3 was up on the web ?
19:58 < clark|w> yeah
19:58 < tglx> half an hour or so
19:59 < clark|w> because I got it, built/booted it (64-bit) and was running it 
                 up til thismorning when I saw that you'd released -rt4 :)
19:59 < tglx> 64bit was fine
19:59 < tglx> I fixed a 32bit PAE bug in -rt2 and when I pushed out -rt3 I did 
              not notice that half of the fix was lost
20:00 < tglx> so I zapped it and pushed out rt4
20:00 < clark|w> cool
20:00 < clark|w> good think I'm 64bit clean :)
20:00 < tglx> but I was too tired to send out another mail

Just FYI
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
