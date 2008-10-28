Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbYJ1RzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbYJ1RzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYJ1Ry7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:54:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33094 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYJ1Ry6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:54:58 -0400
Date: Tue, 28 Oct 2008 18:54:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC git pull] tracing fixes
Message-ID: <20081028175437.GA9559@elte.hu>
References: <20081028164615.GA13425@elte.hu> <alpine.LFD.2.00.0810280953250.3386@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810280953250.3386@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 28 Oct 2008, Ingo Molnar wrote:
> 
> > While writing up this pull request i noticed that the diffstat of this 
> > tree grew unusually large :-(
> > 
> > Hence i changed it to an RFC pull request - and if it's not acceptable 
> > we will rebase it to be smaller.
> 
> The things that make it large are also the main things I like about 
> it (that FTRACE config option confusion and the removal of the nasty 
> daemon), so I pulled it.

great, thanks!

	Ingo
