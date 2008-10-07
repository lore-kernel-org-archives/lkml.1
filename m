Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYJGPtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYJGPtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYJGPtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:49:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:33629 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbYJGPtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:49:15 -0400
Subject: Re: [Bug #11207] VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Miao Xie <miaox@cn.fujitsu.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <200810080211.42210.nickpiggin@yahoo.com.au>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.S8B.b975IB@wind>
	 <200810080211.42210.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 17:48:46 +0200
Message-Id: <1223394526.26330.52.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 02:11 +1100, Nick Piggin wrote:
> On Sunday 05 October 2008 04:28, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11207
> > Subject		: VolanoMark regression with 2.6.27-rc1
> > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date		: 2008-07-31 3:20 (66 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121747464114335&w=4
> > Handled-By	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > 		  Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 		  Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > 		  Miao Xie <miaox@cn.fujitsu.com>
> 
> Curious: what's happening with this one, handlers? Any progress being made?

Sadly not much, I can't seem to reproduce :-(

Yanmin, does the wakeup patch I did for oltp help this workload any?

http://marc.info/?l=linux-kernel&m=122194673932703&w=4



