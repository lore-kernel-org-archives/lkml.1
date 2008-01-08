Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbYAHKeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbYAHKeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYAHKd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:33:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49165 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYAHKd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:33:58 -0500
Date: Tue, 8 Jan 2008 11:33:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: vatsa@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, dmitry.adamushko@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 12/11] sched: rt-group: uid-group interface
Message-ID: <20080108103332.GE6906@elte.hu>
References: <20080106161128.152634000@chello.nl> <1199703080.7143.24.camel@twins> <20080107122330.GB25945@linux.vnet.ibm.com> <1199725063.31975.53.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199725063.31975.53.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0062]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Subject: sched: rt-group: add uid-group interface
> 
> Extend the /sys/kernel/uids/<uid>/ interface to allow setting the 
> group's rt_period and rt_runtime.

thanks, applied.

	Ingo
