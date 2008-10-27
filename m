Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbYJ0K2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbYJ0K2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYJ0K2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:28:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54656 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYJ0K2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:28:07 -0400
Date: Mon, 27 Oct 2008 11:27:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RESEND] ftrace: Add a script to produce a hierarchical
	view of a function trace
Message-ID: <20081027102757.GK8116@elte.hu>
References: <4904DF39.9070203@gmail.com> <alpine.DEB.1.10.0810261903110.26269@gandalf.stny.rr.com> <490513D5.7080806@gmail.com> <20081027100148.GB8116@elte.hu> <c62985530810270326v79528ca9ne88c2c3c9da6558c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810270326v79528ca9ne88c2c3c9da6558c@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/10/27 Ingo Molnar <mingo@elte.hu>:
> > nice! Applied it to tip/tracing/ftrace. I've added Steve's Acked-by,
> 
> 
> Thanks!
> 
> 
> > and i've moved the script to scripts/tracing/ - now that we'll have a
> > handful of utility scripts there we might as well separate it a bit
> > more clearly from the usual body of kernel scripts.
> >
> > i think we should move the other utility scripts there too. (but not
> > the recordmcount script - that is an infrastructure script, not a
> > utility script)
> 
> 
> Good idea, for example bootgraph.pl matches the case, if Arjan agrees.

(Cc:-ed Arjan)

	Ingo
