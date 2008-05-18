Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbYERSlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbYERSlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbYERSiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:38:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58991 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbYERSiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:38:22 -0400
Subject: Re: [Bug #10648] CONFIG_PRINTK_TIME broken on git HEAD ?
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1211131275.6463.5.camel@lappy.programming.kicks-ass.net>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.Xw.7sBMIB@albercik>
	 <1211131275.6463.5.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Sun, 18 May 2008 20:37:35 +0200
Message-Id: <1211135855.6463.20.camel@lappy.programming.kicks-ass.net>
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
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10648
> > Subject		: CONFIG_PRINTK_TIME broken on git HEAD ?
> > Submitter	: Gabriel C <nix.or.die@googlemail.com>
> > Date		: 2008-05-08 00:26 (11 days old)
> > References	: http://lkml.org/lkml/2008/5/7/352
> > Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > 
> 
> Could people test this:
> 
> git://git.kernel.org/home/peterz/git/linux-2.6-sched.git/ v2.6.26-rc2-group-load-balance


Seems I got my own url wrong - the right one is:

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git v2.6.26-rc2-group-load-balance


