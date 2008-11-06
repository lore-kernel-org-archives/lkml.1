Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYKFGsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYKFGsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYKFGsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:48:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43557 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYKFGr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:47:59 -0500
Date: Thu, 6 Nov 2008 07:47:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/1] ring-buffer: raw spinlock fix
Message-ID: <20081106064746.GB15731@elte.hu>
References: <20081106053029.595679750@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106053029.595679750@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> Steven Rostedt (1):
>       ring-buffer: convert to raw spinlocks

i've pulled these 3 commits from you:

 77b93a0: ring-buffer: convert to raw spinlocks
 615a23a: ftrace: restructure tracing start/stop infrastructure
 93411d5: ftrace: soft tracing stop and start
 da0f875: ftrace: add quick function trace stop

I topicized them into tip/tracing/ftrace, so the sha1's are different.

thanks Steve!

	Ingo
