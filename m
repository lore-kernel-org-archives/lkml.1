Return-Path: <linux-kernel-owner+w=401wt.eu-S965105AbXDUH4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbXDUH4B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965287AbXDUH4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:56:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58059 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965105AbXDUH4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:56:00 -0400
Date: Sat, 21 Apr 2007 09:55:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "mdew ." <some.nzguy@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] CFS scheduler, v4, for v2.6.20.7
Message-ID: <20070421075543.GA25451@elte.hu>
References: <20070420140457.GA14017@elte.hu> <1c1c86360704201439u26f06de4j3b7a53145b9e96e2@mail.gmail.com> <20070421064707.GA11173@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070421064707.GA11173@elte.hu>
User-Agent: Mutt/1.4.2.2i
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Any chance of supporting 2.6.20?
> 
> okay, it seems it was less work to backport it to v2.6.20 than it was 
> to answer all the "where's the v2.6.20 version?" emails ;-) You can 
> download the v2.6.20.7 version of CFS from:
> 
>     http://redhat.com/~mingo/cfs-scheduler/sched-cfs-v4-v2.6.20.7.patch
> 
> let me know how well it works for you and how it compares to the 
> vanilla scheduler and/or other schedulers you might have tried.

(and i changed the subject line as well, so that people can find this 
mail on lkml, if they want to.)

	Ingo
