Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbZLaJ7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbZLaJ7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 04:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZLaJ7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 04:59:41 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:51462 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZLaJ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 04:59:40 -0500
Date: Thu, 31 Dec 2009 10:59:37 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, stable@kernel.org
Subject: Re: [Bug #14630] sched_rt_periodic_timer vs cpu hotplug
Message-ID: <20091231095937.GA7098@osiris.boeblingen.de.ibm.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
 <1262104619.7135.161.camel@laptop>
 <20091230081800.GA4304@osiris.boeblingen.de.ibm.com>
 <200912302229.46223.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912302229.46223.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 10:29:46PM +0100, Rafael J. Wysocki wrote:
> On Wednesday 30 December 2009, Heiko Carstens wrote:
> > On Tue, Dec 29, 2009 at 05:36:59PM +0100, Peter Zijlstra wrote:
> > > On Tue, 2009-12-29 at 16:28 +0100, Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of regressions introduced between 2.6.31 and 2.6.32.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > > > be listed and let me know (either way).
> > > > 
> > > > 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14630
> > > > Subject		: sched_rt_periodic_timer vs cpu hotplug
> > > > Submitter	: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > > Date		: 2009-11-11 10:18 (49 days old)
> > > > References	: http://marc.info/?l=linux-kernel&m=125793470309588&w=4
> > > > Handled-By	: Peter Zijlstra <peterz@infradead.org>
> > > > Patch		: http://patchwork.kernel.org/patch/60250/
> > > 
> > > git branch -a --contains 047106ad
> > > 
> > > seems to suggest that this made it to Linus' tree.
> > 
> > Any chance to get this into -stable? Since it seems it got only merged
> > after 2.6.32.
> 
> Can you please send a notification to stable@kernel.org (CC to Greg KH perhaps)?

Sure, here we go ;)
