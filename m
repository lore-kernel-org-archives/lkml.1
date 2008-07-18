Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbYGRWT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbYGRWT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761285AbYGRWRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:17:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761260AbYGRWRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:17:49 -0400
Date: Sat, 19 Jul 2008 00:17:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [git pull] core/percpu for v2.6.27
Message-ID: <20080718221730.GB31073@elte.hu>
References: <20080714143413.GA19134@elte.hu> <alpine.LFD.1.10.0807141525000.2944@woody.linux-foundation.org> <487CC671.3000501@goop.org> <20080715210002.GA7072@elte.hu> <487D15FC.1060300@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D15FC.1060300@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> 
> ...
> > 
> > in hindsight core/percpu indeed looks unfinished and direction-less 
> > without core/percpu-zerobased - but the latter is not stable yet.
> > 
> > 	Ingo
> 
> Well it's very stable using gcc-4.2.4.  The earlier problems came 
> about using gcc-4.2.0 and has yet to be determined what exactly went 
> wrong. (And I need to install gcc-3.2 to complete the build/test QA.)

well, the crash report i gave you was with gcc-4.2.3. Or is that one 
resolved?

	Ingo
