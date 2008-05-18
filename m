Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbYERSqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbYERSqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbYERSkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:40:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050AbYERSkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:40:06 -0400
Subject: Re: [Bug #10638] sysbench+mysql(oltp, readonly) 30% regression
	with 2.6.26-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1211131278.6463.7.camel@lappy.programming.kicks-ass.net>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.IMB.TtBMIB@albercik>
	 <1211131278.6463.7.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Sun, 18 May 2008 20:37:36 +0200
Message-Id: <1211135856.6463.22.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-18 at 19:21 +0200, Peter Zijlstra wrote:
> On Sun, 2008-05-18 at 13:13 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10638
> > Subject		: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
> > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date		: 2008-05-07 4:55 (12 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121013681527052&w=2
> > Handled-By	: Ingo Molnar <mingo@elte.hu>
> > Patch		: http://marc.info/?l=linux-kernel&m=121015292616802&w=2
> > 
> > 
> 
> Could people test this:
> 
> git://git.kernel.org/home/peterz/git/linux-2.6-sched.git/ v2.6.26-rc2-group-load-balance

Seems I got my own url wrong - the right one is:

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git v2.6.26-rc2-group-load-balance



