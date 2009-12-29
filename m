Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZL2QhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZL2QhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 11:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbZL2QhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 11:37:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:55887 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZL2QhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 11:37:24 -0500
Subject: Re: [Bug #14630] sched_rt_periodic_timer vs cpu hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <srmJ8vMxKPH.A.UwD.jxhOLB@chimera>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
	 <srmJ8vMxKPH.A.UwD.jxhOLB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 17:36:59 +0100
Message-ID: <1262104619.7135.161.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-29 at 16:28 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14630
> Subject		: sched_rt_periodic_timer vs cpu hotplug
> Submitter	: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date		: 2009-11-11 10:18 (49 days old)
> References	: http://marc.info/?l=linux-kernel&m=125793470309588&w=4
> Handled-By	: Peter Zijlstra <peterz@infradead.org>
> Patch		: http://patchwork.kernel.org/patch/60250/

git branch -a --contains 047106ad

seems to suggest that this made it to Linus' tree.

