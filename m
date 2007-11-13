Return-Path: <linux-kernel-owner+w=401wt.eu-S1761413AbXKMUxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413AbXKMUxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbXKMUxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:53:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40435 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384AbXKMUxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:53:16 -0500
Date: Tue, 13 Nov 2007 12:52:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, alsa-devel@alsa-project.org,
       netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, protasnb@gmail.com,
       linux-ide@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [BUG] New Kernel Bugs
Message-Id: <20071113125222.9eb53ac8.akpm@linux-foundation.org>
In-Reply-To: <20071113193219.GC1356@flint.arm.linux.org.uk>
References: <20071113034916.2556edd7.akpm@linux-foundation.org>
	<20071113.035824.40509981.davem@davemloft.net>
	<20071113041259.79c9a8c5.akpm@linux-foundation.org>
	<20071113.043207.44732743.davem@davemloft.net>
	<20071113193219.GC1356@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 19:32:19 +0000 Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> There's another issue I want to raise concerning bugzilla.  We have the
> classic case of "not enough people reading bugzilla bugs" - which is one
> of the biggest problems with bugzilla.  Virtually no one in the ARM
> community looks for ARM bugs in bugzilla.

Nor should they.

> Let's not forget that it would be a waste of time for people to manually
> check bugzilla for ARM bugs.  There's soo few people reporting ARM bugs
> into bugzilla that a weekly manual check by every maintainer would just
> return the same old boring results for months and months at a time.

I screen all bugzilla reports.  100% of them.

- I'll try to establish whether it is a regression

- I'll solicit any extra information which I believe the reveloper will need

- I'll ensure that an appropriate developer has seen the report

And yes, the number of arm-specific reports in there is very small.

> It would be far more productive if the ARM category was deleted from
> bugzilla and the few people who use bugzilla reported their bugs on the
> mailing list.  We've a couple of thousand people on the ARM kernel
> mailing list at the moment - that's 3 orders of magnitude more of eyes
> than look at bugzilla.

Is that linux-arm-kernel@lists.arm.linux.org.uk?

If so, MANITAINERS claims that it is subscribers-only.  That would cause
some bug reporters to give up and go away.
