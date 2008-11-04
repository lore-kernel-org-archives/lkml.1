Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYKDJOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYKDJOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbYKDJNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:13:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38472 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbYKDJNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:13:23 -0500
Date: Tue, 4 Nov 2008 10:13:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace document version update
Message-ID: <20081104091303.GF23790@elte.hu>
References: <alpine.DEB.1.10.0810231921590.4182@gandalf.stny.rr.com> <20081026193339.91e0c644.randy.dunlap@oracle.com> <alpine.DEB.1.10.0810311102280.20404@gandalf.stny.rr.com> <20081031093152.efbb65c1.randy.dunlap@oracle.com> <alpine.DEB.1.10.0810311245160.22754@gandalf.stny.rr.com> <alpine.DEB.1.10.0811031518340.16323@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811031518340.16323@gandalf.stny.rr.com>
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

> 
> Impact: Documentation update only
>  
> Update the version that the ftrace document was written for.
>  
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  Documentation/ftrace.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied	to tip/tracing/urgent, thanks Steve!

	Ingo
