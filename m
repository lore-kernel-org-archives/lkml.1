Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZL3ISH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZL3ISH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 03:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZL3ISF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 03:18:05 -0500
Received: from mtagate6.de.ibm.com ([195.212.17.166]:49902 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbZL3ISD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 03:18:03 -0500
Date: Wed, 30 Dec 2009 09:18:00 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14630] sched_rt_periodic_timer vs cpu hotplug
Message-ID: <20091230081800.GA4304@osiris.boeblingen.de.ibm.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
 <srmJ8vMxKPH.A.UwD.jxhOLB@chimera>
 <1262104619.7135.161.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262104619.7135.161.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 05:36:59PM +0100, Peter Zijlstra wrote:
> On Tue, 2009-12-29 at 16:28 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14630
> > Subject		: sched_rt_periodic_timer vs cpu hotplug
> > Submitter	: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Date		: 2009-11-11 10:18 (49 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125793470309588&w=4
> > Handled-By	: Peter Zijlstra <peterz@infradead.org>
> > Patch		: http://patchwork.kernel.org/patch/60250/
> 
> git branch -a --contains 047106ad
> 
> seems to suggest that this made it to Linus' tree.

Any chance to get this into -stable? Since it seems it got only merged
after 2.6.32.
