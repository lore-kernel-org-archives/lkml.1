Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZHFHxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZHFHxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 03:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZHFHxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 03:53:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49593 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZHFHxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:53:00 -0400
Date: Thu, 6 Aug 2009 09:52:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Phillips <phillips@phunq.net>, Jeff Garzik <jgarzik@pobox.com>
Cc: debian developer <debiandev@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, tux3@tux3.org,
       LKML <linux-kernel@vger.kernel.org>, corbet@lwn.net
Subject: Re: [Tux3] Current Activities?
Message-ID: <20090806075246.GA6860@elte.hu>
References: <6dcc37b30904291901m7abdd6d7q6f44b2c248ec48c4@mail.gmail.com> <200904302049.27235.phillips@phunq.net> <f24d23310907310210w4406f596nc5b85a7ff41ee40c@mail.gmail.com> <200908010942.52623.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908010942.52623.phillips@phunq.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Phillips <phillips@phunq.net> wrote:

> [...]  I will say this now: if we are invited to merge in the next 
> major release, or in -mm or whatever, we will happily do it. If we 
> are not invited to merge, nobody has any cause to complain about 
> progress slowing down. [...]

The thing is, if you are waiting for an 'invite to upstream Linux 
merge' that could be a _very_ long wait: i've yet to see a single 
one ever since i started hacking Linux ~14 years ago ;-)

The model that Linux has been following for the past 10+ years is 
for new kernel projects to request inclusion. I.e. you push your 
patches upstream: you send patches and a pull request to the 
appropriate people/lists such as lkml.

This is done so because merging patches is a fundamentally 
hierarchical process, and the people merging _your_ patches are the 
real maintenance bottleneck, not you.

So it is not Linus and other maintainers who are searching the web 
for projects to merge and sending out 'invites' but the other way 
around: projects try to get upstream by submitting patches (which 
get reviewed and accepted or rejected).

So if you'd like your code to be merged upstream you better start 
this process now - this alone can take a lot of time: months (or 
years in certain cases). But it is still a much shorter time-span 
than an 'invite to merge' ;-)

	Ingo
