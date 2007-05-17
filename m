Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbXEQTly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbXEQTly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbXEQTls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:41:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36212 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbXEQTlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:41:47 -0400
Date: Thu, 17 May 2007 21:41:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: v2.6.21-rt3
Message-ID: <20070517194143.GA25394@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i'm pleased to announce the v2.6.21-rt3 kernel, which can be downloaded 
from the usual place:

    http://redhat.com/~mingo/realtime-preempt/
 
more info about the -rt patchset can be found in the RT wiki:
 
    http://rt.wiki.kernel.org

This is a fixes-only release assembled by Thomas Gleixner. Many PPC 
fixes from Sergei Shtylyov, dynticks softirq fixes from Mikulas Patocka, 
a CONFIG_IRQSOFF_TIMING fix from Daniel Walker and x86_64 hrt fixes from 
Thomas Gleixner.

to build a 2.6.21-rt3 tree, the following patches should be applied:

  http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.tar.bz2
  http://redhat.com/~mingo/realtime-preempt/patch-2.6.21-rt3

	Ingo
