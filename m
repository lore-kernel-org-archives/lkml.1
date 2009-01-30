Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbZA3JEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbZA3JEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZA3JDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:03:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54456 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZA3JDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:03:47 -0500
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
 scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Nathanael Hoyle <nhoyle@hoyletech.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
In-Reply-To: <1233306030.17301.36.camel@localhost>
References: <1233294584.28741.2.camel@localhost>
	 <1233305433.4495.154.camel@laptop>  <1233306030.17301.36.camel@localhost>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 10:03:43 +0100
Message-Id: <1233306223.4495.159.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 04:00 -0500, Nathanael Hoyle wrote:
> On Fri, 2009-01-30 at 09:50 +0100, Peter Zijlstra wrote:
> > On Fri, 2009-01-30 at 00:49 -0500, Nathanael Hoyle wrote:
> > > 
> > > 1) Is my problem 'expected' based on others' understanding of the
> > > current design of the scheduler, or do I have a one-off problem to
> > > troubleshoot here?
> > 
> > What kernel are you running (or did my eye glance over that detail in
> > your longish email) ?
> > 
> 
> I didn't include it, I should have:
> 
> $ uname -a
> Linux nightmare 2.6.27-gentoo-r7-nhoyle #2 SMP Wed Jan 28 19:04:37 EST
> 2009 x86_64 Intel(R) Core(TM)2 Quad CPU Q9450 @ 2.66GHz GenuineIntel
> GNU/Linux

Ah, then please do as Mike suggested, try 28.2 or 29-rc3, if you still
have trouble with those, please let us know.

