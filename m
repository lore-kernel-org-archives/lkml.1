Return-Path: <linux-kernel-owner+w=401wt.eu-S1751391AbZJWHgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbZJWHgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 03:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZJWHgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 03:36:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34354 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZJWHgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 03:36:09 -0400
Date: Fri, 23 Oct 2009 09:35:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2 -tip] perf: Keep track of remaining time when
	enabling/disabling swevent hrtimers
Message-ID: <20091023073556.GD19169@elte.hu>
References: <ye8vdi7mluz.fsf@camel16.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ye8vdi7mluz.fsf@camel16.daimi.au.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Soeren Sandmann <sandmann@daimi.au.dk> wrote:

> Hi,
> 
> These patches against perf/core make the hrtimer based events work for
> sysprof.
> 
> 1/2: Don't restart the timer on every scheduler tick
> 2/2: If exclude_idle is set, don't report idle events.

Applied to tip:perf/urgent, thanks a lot Soeren!

	Ingo
