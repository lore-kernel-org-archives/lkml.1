Return-Path: <linux-kernel-owner+w=401wt.eu-S1761185AbXFIUlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761185AbXFIUlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbXFIUlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:41:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55408 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbXFIUlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:41:00 -0400
Date: Sat, 9 Jun 2007 22:40:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: v2.6.21.4-rt10
Message-ID: <20070609204054.GA24503@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i'm pleased to announce the v2.6.21.4-rt10 kernel, which can be 
downloaded from the usual place:

     http://redhat.com/~mingo/realtime-preempt/
  
more info about the -rt patchset can be found in the RT wiki:
  
     http://rt.wiki.kernel.org

This is a fixes-only release assembled by Thomas Gleixner again. On 
popular request this -rt tree is against the stable dot kernel - i.e. 
apply it to a v2.6.21.4 tree, not a v2.6.21 tree.

-rt10 includes the futex fixes and the latest hrtimer updates from 
Thomas Gleixner, latency tracer fixes from Carsten Emde, tasklet fix 
from John Stultz, rcu tasklet -> softirq conversion and the 
enable-irqs-in-pagefaults fix from Steven Rostedt, and other, smaller 
fixes.

to build a 2.6.21.4-rt10 tree, the following patches should be applied:
 
   http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.4.tar.bz2
   http://redhat.com/~mingo/realtime-preempt/patch-2.6.21.4-rt10
 
	Ingo
