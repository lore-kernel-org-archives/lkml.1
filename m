Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbYF0Q6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbYF0Q6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYF0Q6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:58:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17955 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYF0Q6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:58:47 -0400
Date: Fri, 27 Jun 2008 09:56:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip/master] x86: nmi_watchdog - documentation fix
Message-Id: <20080627095608.649e819a.randy.dunlap@oracle.com>
In-Reply-To: <20080627165125.GE18957@cvg>
References: <20080627154340.GC18957@cvg>
	<Pine.LNX.4.55.0806271652020.8868@cliff.in.clinika.pl>
	<20080627165937.2f1fb661@lxorguk.ukuu.org.uk>
	<4865160C.2040403@nortel.com>
	<20080627165125.GE18957@cvg>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 20:51:25 +0400 Cyrill Gorcunov wrote:

> [Chris Friesen - Fri, Jun 27, 2008 at 10:32:12AM -0600]
> > Alan Cox wrote:
> >> On Fri, 27 Jun 2008 16:54:19 +0100 (BST)
> >> "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
> >>> On Fri, 27 Jun 2008, Cyrill Gorcunov wrote:
> >>>
> >>>
> >>>> +NOTE: Prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
> >>>> +on x86 SMP boxes.
> >>>
> >>> While you are at it: s/is/was/.
> >> Erm - why ??
> >> It is still true today that kernels < 2.4.2-ac8 have the NMI oopser
> >> enabled.
> >
> > To my ear the phrase as written implies past tense for the author/reader 
> > (i.e. "at points in time prior to the release of 2.4.2-ac18"), and thus 
> > grates against "is".
> >
> > The following sounds better to me: "In kernels prior to 2.4.2-ac18 the 
> > NMI-oopser is enabled..."  In this context the phrase itself is in the 
> > present, but we point to past kernels.
> >
> > Chris
> >
> 
> And the winner is? I'm not native English speaker so I can't select
> a better candidate in {is,was} limited set.

Use the text that Chris suggested...


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
