Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbZKXHrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbZKXHrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757723AbZKXHrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:47:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45905 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757669AbZKXHrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:47:10 -0500
Date: Tue, 24 Nov 2009 08:47:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Arjan van de Ven <arjan@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] perf kmem: Add more functions and show more
 statistics
Message-ID: <20091124074703.GB21991@elte.hu>
References: <4B0B6E44.6090106@cn.fujitsu.com>
 <84144f020911232315h7c8b7348u9ad97f585f54a014@mail.gmail.com>
 <20091124073426.GA21991@elte.hu>
 <84144f020911232345j75c93ec6mf1fc426262c14eb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020911232345j75c93ec6mf1fc426262c14eb0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Ingo,
> 
> On Tue, Nov 24, 2009 at 9:34 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > Certainly we can postpone it, as long as there's rough strategic
> > consensus on the way forward. I'd hate to have two overlapping core
> > kernel facilities and friction between the groups pursuing them and
> > constant distraction from having two targets.
> 
> Sure, like I said, I think "kmem perf" is the way forward. The only 
> reason we did kmemtrace userspace out-of-tree was because there was no 
> perf (or ftrace!) at the time and there wasn't much interest in 
> putting userspace tools in the tree.
> 
> I hope that counts as a "rough strategic consensus" :-)

it does :-)

	Ingo
