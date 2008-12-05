Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbYLENw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbYLENw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYLENwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:52:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49354 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYLENwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:52:18 -0500
Date: Fri, 5 Dec 2008 14:51:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] ftrace: use init_struct_pid as swapper pid
Message-ID: <20081205135150.GD27039@elte.hu>
References: <20081204052638.425740534@goodmis.org> <20081204052735.362609481@goodmis.org> <20081204001803.598063f5.akpm@linux-foundation.org> <20081204091023.GJ32594@elte.hu> <m1vdu0t7tz.fsf@frodo.ebiederm.org> <alpine.DEB.1.10.0812040946060.5240@gandalf.stny.rr.com> <m11vwnu10b.fsf@frodo.ebiederm.org> <alpine.DEB.1.10.0812041551590.32726@gandalf.stny.rr.com> <m1vdtzr4zn.fsf@frodo.ebiederm.org> <alpine.DEB.1.10.0812042323120.26316@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812042323120.26316@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Here's a little clean up patch.
> 
> Randy Dunlap should be happy that I changed my script to combine the 
> header and patch in one email if I only have a single patch.
> 
> -- Steve
> 
> The following patch is in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Steven Rostedt (1):
>       ftrace: use init_struct_pid as swapper pid
> 
> ----
>  kernel/trace/ftrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> ---------------------------

pulled, thanks Steve!

	Ingo
