Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbZL2VWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbZL2VWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZL2VWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:22:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40462 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbZL2VWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:22:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #14630] sched_rt_periodic_timer vs cpu hotplug
Date: Tue, 29 Dec 2009 22:22:37 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.UwD.jxhOLB@chimera> <1262104619.7135.161.camel@laptop>
In-Reply-To: <1262104619.7135.161.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912292222.37666.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, Peter Zijlstra wrote:
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

Thanks, closing.

Rafael
