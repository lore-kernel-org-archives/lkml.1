Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbXFOPbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbXFOPbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbXFOPbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:31:10 -0400
Received: from www.osadl.org ([213.239.205.134]:53404 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754250AbXFOPbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:31:08 -0400
Subject: Re: Jinxed VAIO wreckage - current state of affairs
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>
In-Reply-To: <20070615082324.203610ec.randy.dunlap@oracle.com>
References: <1181418873.4404.402.camel@chaos>
	 <200706092259.50694.rjw@sisk.pl>
	 <20070609200827.635fec79.akpm@linux-foundation.org>
	 <1181909157.8176.342.camel@chaos>
	 <20070615082324.203610ec.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 17:31:06 +0200
Message-Id: <1181921466.8176.356.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 08:23 -0700, Randy Dunlap wrote:
> On Fri, 15 Jun 2007 14:05:57 +0200 Thomas Gleixner wrote:
> 
> > On Sat, 2007-06-09 at 20:08 -0700, Andrew Morton wrote:
> > > On Sat, 9 Jun 2007 22:59:49 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > Hmm, how's 2.6.22-rc4-mm2 doing on the Vaio?
> > > 
> > > People would have heard if it was busted ;)
> > 
> > Just found a brown paperbag bug in the resume patch logic. Sigh, I was
> > staring at that code for month without noticing.
> > 
> > Andrew,
> > 
> > can you please test
> > 
> > http://www.tglx.de/projects/hrtimers/2.6.22-rc4/patch-2.6.22-rc4-hrt9.patch
> 
> bad URL, not found.

http://www.tglx.de/projects/hrtimers/2.6.22-rc4/patch-2.6.22-rc4-hrt10.patch

	tglx


