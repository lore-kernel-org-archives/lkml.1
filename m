Return-Path: <linux-kernel-owner+w=401wt.eu-S935358AbXG2P0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935358AbXG2P0y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934417AbXG2PUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:20:53 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:62733 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933844AbXG2PUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:20:50 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: Linus 2.6.23-rc1
Date: Sun, 29 Jul 2007 17:20:46 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200707290141.19790.volker.armin.hemmann@tu-clausthal.de> <1185669631.1432.2.camel@localhost>
In-Reply-To: <1185669631.1432.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291720.46336.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonntag, 29. Juli 2007, Kasper Sandberg wrote:
> On Sun, 2007-07-29 at 01:41 +0200, Volker Armin Hemmann wrote:
> > Hi,
> >
> > I never tried Con's patchset, for two reasons:
> > I tried his 2.4 patches ones, and I never saw any improvements. So when
> > people were reporting huge improvements with his SD scheduler, I compared
> > that with the reports of huge improvements with his 2.4 kernel patches.
>
> Well thats a reason if there ever were one...
>

yes, it is. The fans claimed once lots of stuff that was not true for me. So 
why believing them 'now'?

> > ...
> > The second: too many patches. I only would have tried one or two, but the
> > ck-patchset is a lot bigger.. and I am a little bit uneasy about that.
>
> so use only the scheduler? nobody forces you to do many things..

but which one is needed?
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.22/2.6.22-ck1/patches/

six patches who start with 'sched-' and which one is needed? and which is not? 
Can I only use sched-staircase-deadline-cpu-scheduler.patch  or do I need the 
others too?

> Better than old vanilla yes, but than SD? well, you should give it a
> try.
>

see above.
