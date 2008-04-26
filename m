Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYDZOsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYDZOsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYDZOsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:48:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53699 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYDZOsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:48:33 -0400
Date: Sat, 26 Apr 2008 16:48:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: make rt_sched_class, idle_sched_class static
Message-ID: <20080426144820.GB19635@elte.hu>
References: <1209145993.20088.16.camel@brick> <1209146131.1956.8.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209146131.1956.8.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2008-04-25 at 10:53 -0700, Harvey Harrison wrote:
> > The C files are included directly in sched.c, so they are
> > effectively static.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

thanks, applied.

	Ingo
