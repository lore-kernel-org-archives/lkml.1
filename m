Return-Path: <linux-kernel-owner+w=401wt.eu-S933499AbZDJNEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499AbZDJNEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757755AbZDJNEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:04:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51907 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbZDJNEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:04:30 -0400
Date: Fri, 10 Apr 2009 15:04:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [tip:tracing/urgent] tracing: consolidate documents
Message-ID: <20090410130403.GB31307@elte.hu>
References: <49DD6E2B.6090200@cn.fujitsu.com> <tip-66bb74888eb4bef4ba7c87c931ecb7ecca3a240c@git.kernel.org> <20090409185320.4ccba2df@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409185320.4ccba2df@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Pekka Paalanen <pq@iki.fi> wrote:

> On Thu, 9 Apr 2009 05:30:47 GMT
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > Commit-ID:  66bb74888eb4bef4ba7c87c931ecb7ecca3a240c
> > Gitweb:     http://git.kernel.org/tip/66bb74888eb4bef4ba7c87c931ecb7ecca3a240c
> > Author:     Li Zefan <lizf@cn.fujitsu.com>
> > AuthorDate: Thu, 9 Apr 2009 11:40:27 +0800
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Thu, 9 Apr 2009 07:28:10 +0200
> > 
> > tracing: consolidate documents
> > 
> > Move kmemtrace.txt, tracepoints.txt, ftrace.txt and mmiotrace.txt to
> > the new trace/ directory.
> > 
> > I didnt find any references to those documents in both source
> > files and documents, so no extra work needs to be done.
> 
> There is one reference: kernel/trace/Kconfig, search for MMIOTRACE.
> Fix that, and you have my ack on the mmiotrace.txt part.

This fix is committed now so your ack now takes effect :)

> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > Acked-by: Pekka Paalanen <pq@iki.fi>
> 
> Hey, I didn't say anything yet. Maybe you meant Enberg?
> There are at least two Pekkas here :-)

Yeah, you should rename yourself and pick some unique name like 
Ingo. Oh wait ...

	Ingo
