Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbYKDJN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbYKDJN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbYKDJNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:13:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36618 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbYKDJNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:13:12 -0500
Date: Tue, 4 Nov 2008 10:12:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: update txt document
Message-ID: <20081104091252.GE23790@elte.hu>
References: <alpine.DEB.1.10.0810231921590.4182@gandalf.stny.rr.com> <20081026193339.91e0c644.randy.dunlap@oracle.com> <alpine.DEB.1.10.0810311102280.20404@gandalf.stny.rr.com> <alpine.DEB.1.10.0811031514120.16323@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811031514120.16323@gandalf.stny.rr.com>
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

> Impact: Documentation update only
> 
> A lot of changes have gone into ftrace. This patch updates
> the ftrace.txt document.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/ftrace.txt |  169 ++++++++++++++++++++---------------------------
>  1 file changed, 72 insertions(+), 97 deletions(-)

applied to tip/tracing/urgent, thanks Steve!

	Ingo
