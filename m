Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbXKMXgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbXKMXgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758664AbXKMXgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:36:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39421 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133AbXKMXgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:36:10 -0500
Date: Tue, 13 Nov 2007 23:29:54 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       alsa-devel@alsa-project.org, netdev@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       protasnb@gmail.com, linux-ide@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113232954.GK1356@flint.arm.linux.org.uk>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
	alsa-devel@alsa-project.org, netdev@vger.kernel.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	protasnb@gmail.com, linux-ide@vger.kernel.org,
	bugme-daemon@bugzilla.kernel.org,
	linux-input@atrey.karlin.mff.cuni.cz
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113.043207.44732743.davem@davemloft.net> <20071113193219.GC1356@flint.arm.linux.org.uk> <20071113201319.GL4250@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113201319.GL4250@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 09:13:19PM +0100, Adrian Bunk wrote:
> On Tue, Nov 13, 2007 at 07:32:19PM +0000, Russell King wrote:
> >...
> > There's another issue I want to raise concerning bugzilla.  We have the
> > classic case of "not enough people reading bugzilla bugs" - which is one
> > of the biggest problems with bugzilla.  Virtually no one in the ARM
> > community looks for ARM bugs in bugzilla.
> > 
> > Let's not forget that it would be a waste of time for people to manually
> > check bugzilla for ARM bugs.  There's soo few people reporting ARM bugs
> > into bugzilla that a weekly manual check by every maintainer would just
> > return the same old boring results for months and months at a time.
> >...
> 
> What about having all ARM bugs in Bugzilla by default assigned to 
> linux-arm-kernel@lists.arm.linux.org.uk? [1]

That would also work, probably much better than setting up yet another
list.

My experience of trying to get mbligh to do this when I stopped looking
after PCMCIA stuff was *extremely* painful.  Wonder if it's become any
easier of late?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
