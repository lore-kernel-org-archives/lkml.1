Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbYAHLRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbYAHLRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYAHLRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:17:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53221 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbYAHLRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:17:14 -0500
Date: Tue, 8 Jan 2008 12:16:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 04/11] hrtimer: fixup the HRTIMER_CB_IRQSAFE_NO_SOFTIRQ
	fallback
Message-ID: <20080108111639.GA30710@elte.hu>
References: <20080106161128.152634000@chello.nl> <20080106162123.431344000@chello.nl> <1199706988.7143.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199706988.7143.30.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Sun, 2008-01-06 at 17:11 +0100, Peter Zijlstra wrote:
> > plain text document attachment (hrtimer-fallback.patch)
> 
> I know I should have boot tested more combinations :-(
> Please fold this into the patch.

done.

	Ingo
