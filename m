Return-Path: <linux-kernel-owner+w=401wt.eu-S965714AbXAYIlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965714AbXAYIlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 03:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965715AbXAYIlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 03:41:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55282 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965714AbXAYIlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 03:41:36 -0500
Date: Thu, 25 Jan 2007 09:39:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>, linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] lock stat for -rt 2.6.20-rc2-rt2.2.lock_stat.patch
Message-ID: <20070125083920.GA30163@elte.hu>
References: <9D2C22909C6E774EBFB8B5583AE5291C019998CA@fmsmsx414.amr.corp.intel.com> <20061229232618.GA11239@gnuppy.monkey.org> <20061230111940.GA8412@elte.hu> <20070103074124.GA25594@gnuppy.monkey.org> <20070104044659.GA3097@elte.hu> <20070124230657.GA5362@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124230657.GA5362@gnuppy.monkey.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Huey <billh@gnuppy.monkey.org> wrote:

> Latest patch here.
> 
> 	http://finfin.is-a-geek.org/~billh/contention/patch-2.6.20-rc2-rt2.4.lock_stat.patch
>
> I'm going to review and hand merge your changes to the older patch 
> tonight.

one more suggestion: please do diffs in -p1 (not in -p0) format.

	Ingo
