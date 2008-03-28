Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYC1KZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYC1KZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYC1KZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:25:17 -0400
Received: from www.tglx.de ([62.245.132.106]:57584 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbYC1KZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:25:16 -0400
Date: Fri, 28 Mar 2008 11:24:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <200803272353.51901.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0803281004440.3781@apollo.tec.linutronix.de>
References: <200803272353.51901.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-564028411-1206695476=:3781"
Content-ID: <alpine.LFD.1.00.0803281118050.3781@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-564028411-1206695476=:3781
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.1.00.0803281118051.3781@apollo.tec.linutronix.de>

On Thu, 27 Mar 2008, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9980
> Subject		: 2.6.25-rc1 on Sun Ultra 40- HPET clocksource which causes it to hang
> Submitter	: Jasper Bryant-Greene <jasper@unix.geek.nz>
> Date		: 2008-02-13 12:25 (44 days old)
> References	: http://lkml.org/lkml/2008/2/13/181
> Handled-By	: Yinghai Lu <Yinghai.Lu@sun.com>

asked the bug reporter for an update.
 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10011
> Subject		: The computer is blocked when X is started - unless max_cstate=2 - Acer Travelmate 4001 Lmi
> Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
> Date		: 2008-02-17 06:28 (40 days old)
> Handled-By	: Thomas Gleixner <tglx@linutronix.de>

asked the bug reporter for an update.
 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9969
> Subject		: 2.6.24-git15 Keyboard Issue?
> Submitter	: Chris Holvenstot <cholvenstot@comcast.net>
> Date		: 2008-02-06 14:02 (51 days old)
> References	: http://lkml.org/lkml/2008/2/6/100
> 		  http://lkml.org/lkml/2008/2/13/82
> Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> Patch		: http://lkml.org/lkml/2008/2/15/343
 
asked the bug reporter for an update.
 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10153
> Subject		: (regression) kernel/timeconst.h bugs with HZ=128
> Submitter	: David Brownell <david-b@pacbell.net>
> Date		: 2008-02-26 19:32 (31 days old)
> References	: http://lkml.org/lkml/2008/2/26/294
> Handled-By	: H. Peter Anvin <hpa@zytor.com>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15114&amp;action=view
> 		  http://bugzilla.kernel.org/attachment.cgi?id=15115&amp;action=view

Have those patches made it somewhere else than into the bugzilla ?

Thanks,

	tglx
--8323328-564028411-1206695476=:3781--
