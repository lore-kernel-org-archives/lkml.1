Return-Path: <linux-kernel-owner+w=401wt.eu-S933196AbXHaSZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbXHaSZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 14:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932808AbXHaSY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 14:24:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48357 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932745AbXHaSY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 14:24:58 -0400
Date: Fri, 31 Aug 2007 20:24:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Track accurate idle time with tick_sched.idle_sleeptime
Message-ID: <20070831182421.GA4119@elte.hu>
References: <20070827215611.GA30396@linux-os.sc.intel.com> <20070831182212.GA3568@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070831182212.GA3568@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> nice stuff! I've added your patch to the scheduler queue - but this 
> will probably be 2.6.24 material.

btw., this patch depends on the latest acpi tree, right?

	Ingo
