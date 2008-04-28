Return-Path: <linux-kernel-owner+w=401wt.eu-S935645AbYD1UFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935645AbYD1UFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765970AbYD1UFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:05:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34290 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765826AbYD1UFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:05:22 -0400
Date: Mon, 28 Apr 2008 22:05:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 1/3] mmiotrace full patch, preview 3
Message-ID: <20080428200503.GB15840@elte.hu>
References: <20080428214504.5c359195@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428214504.5c359195@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> Hi all,
> 
> this is the third full mmiotrace patch set for review (a bit late, 
> sorry). These patches do not apply to any git tree that I know of, but 
> after Ingo pushes a new version of his sched-devel/latest tree, these 
> patches should be subtractable from there.

might not be able to release a new sched-devel.git/x86.git tonight - had 
to filter out lots of badness today from new patches and i dont trust 
the quality of the current lot yet. (nothing mmiotrace related for that 
matter)

	Ingo
