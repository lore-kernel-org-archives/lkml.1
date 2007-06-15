Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbXFOPZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbXFOPZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXFOPZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:25:01 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:40114 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbXFOPZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:25:00 -0400
Date: Fri, 15 Jun 2007 08:23:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>
Subject: Re: Jinxed VAIO wreckage - current state of affairs
Message-Id: <20070615082324.203610ec.randy.dunlap@oracle.com>
In-Reply-To: <1181909157.8176.342.camel@chaos>
References: <1181418873.4404.402.camel@chaos>
	<200706092259.50694.rjw@sisk.pl>
	<20070609200827.635fec79.akpm@linux-foundation.org>
	<1181909157.8176.342.camel@chaos>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 14:05:57 +0200 Thomas Gleixner wrote:

> On Sat, 2007-06-09 at 20:08 -0700, Andrew Morton wrote:
> > On Sat, 9 Jun 2007 22:59:49 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > Hmm, how's 2.6.22-rc4-mm2 doing on the Vaio?
> > 
> > People would have heard if it was busted ;)
> 
> Just found a brown paperbag bug in the resume patch logic. Sigh, I was
> staring at that code for month without noticing.
> 
> Andrew,
> 
> can you please test
> 
> http://www.tglx.de/projects/hrtimers/2.6.22-rc4/patch-2.6.22-rc4-hrt9.patch

bad URL, not found.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
