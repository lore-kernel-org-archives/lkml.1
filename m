Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbYGINw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbYGINw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbYGINwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:52:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43183 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693AbYGINwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:52:17 -0400
Date: Wed, 9 Jul 2008 15:52:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
Message-ID: <20080709135201.GA15866@elte.hu>
References: <m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org> <m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com> <486B8B6C.2050109@firstfloor.org> <m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0807021930470.18105@woody.linux-foundation.org> <m34p71yjyx.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0807070901490.11076@woody.linux-foundation.org> <20080709130305.GB20768@elte.hu> <m3od57nqow.fsf@gravicappa.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3od57nqow.fsf@gravicappa.englab.brq.redhat.com>
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


* Vitaly Mayatskikh <v.mayatskih@gmail.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> >> Obviously, I'd be even happier if it also went through the normal x86 
> >> review cycles (ie Ingo &co), but the current series is largely ack'ed 
> >> by me.
> >
> > applied them to tip/x86/core, for v2.6.27 merging, thanks everyone.
> >
> > I've added Linus's Acked-by. Vitaly, could you please send your 
> > Signed-off-by line, it was missing from the patches. 
> 
> It was wrongly set at the very end of post.
> 
> Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

ok, pushed it out with your signoffs added.

	Ingo
