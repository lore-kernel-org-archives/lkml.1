Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYB2JK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYB2JK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 04:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYB2JKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 04:10:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbYB2JKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 04:10:40 -0500
Date: Fri, 29 Feb 2008 10:10:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Jackson <pj@sgi.com>,
       Max Krasnyanskiy <maxk@qualcomm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-ID: <20080229091018.GA19823@elte.hu>
References: <20080227222103.673194000@chello.nl> <20080228075010.GA28781@elte.hu> <20080229003155.bbab795d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229003155.bbab795d.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> It of course lays waste to a series of cgroup patches from Paul Menage 
> which I already had queued.

Andrew, please stop tracking sched-devel.git and track this tree 
instead:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

thanks,

	Ingo
