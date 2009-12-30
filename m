Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbZL3V3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbZL3V3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZL3V3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:29:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44137 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbZL3V3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:29:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [Bug #14630] sched_rt_periodic_timer vs cpu hotplug
Date: Wed, 30 Dec 2009 22:29:46 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <1262104619.7135.161.camel@laptop> <20091230081800.GA4304@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20091230081800.GA4304@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912302229.46223.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 December 2009, Heiko Carstens wrote:
> On Tue, Dec 29, 2009 at 05:36:59PM +0100, Peter Zijlstra wrote:
> > On Tue, 2009-12-29 at 16:28 +0100, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.31 and 2.6.32.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > > be listed and let me know (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14630
> > > Subject		: sched_rt_periodic_timer vs cpu hotplug
> > > Submitter	: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > Date		: 2009-11-11 10:18 (49 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=125793470309588&w=4
> > > Handled-By	: Peter Zijlstra <peterz@infradead.org>
> > > Patch		: http://patchwork.kernel.org/patch/60250/
> > 
> > git branch -a --contains 047106ad
> > 
> > seems to suggest that this made it to Linus' tree.
> 
> Any chance to get this into -stable? Since it seems it got only merged
> after 2.6.32.

Can you please send a notification to stable@kernel.org (CC to Greg KH perhaps)?

Rafael
