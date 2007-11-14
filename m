Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbXKNKBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbXKNKBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 05:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbXKNKBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 05:01:01 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49036 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbXKNKBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 05:01:00 -0500
Date: Wed, 14 Nov 2007 09:55:07 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, alsa-devel@alsa-project.org,
       protasnb@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071114095507.GA32595@flint.arm.linux.org.uk>
Mail-Followup-To: David Miller <davem@davemloft.net>,
	akpm@linux-foundation.org, netdev@vger.kernel.org,
	linux-pcmcia@lists.infradead.org, alsa-devel@alsa-project.org,
	protasnb@gmail.com, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	linux-input@atrey.karlin.mff.cuni.cz
References: <20071113125222.9eb53ac8.akpm@linux-foundation.org> <20071113221801.GF1356@flint.arm.linux.org.uk> <20071113143201.9441c940.akpm@linux-foundation.org> <20071113.175551.131375600.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113.175551.131375600.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 05:55:51PM -0800, David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 13 Nov 2007 14:32:01 -0800
> 
> > On Tue, 13 Nov 2007 22:18:01 +0000 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > 
> > > Find some other mailing list; I'm not hosting *nor* am I willing to run a
> > > non-subscribers only mailing list.  Period.  Not negotiable, so don't even
> > > try to change my mind.
> > 
> > Making a list subscribers-only will cause some bug reports to be lost.
> > 
> > Tradeoffs are involved, against which decisions must be made.  You have
> > made yours.
> 
> Russell doesn't have to worry any more, he doesn't have to
> host it, and he doesn't have to be willing to run a
> non-subscribers-only mailing list.
> 
> Because I am.
> 
> I've created linux-arm@vger.kernel.org

By doing so you've just said (implicitly) that you can not tolerate
someone having a different opinion from your own.

While I accept *your* right to run *your* lists how you please, you
are unable to accept *my* right to run *my* lists how I see fit.

Time will tell which lists will survive.  Whatever, I suspect that by
doing what you've just done, you're going to create more confusion and
problems. Instead of having one focused place for discussions and bug
reports, they're going to be spread more thinly, meaning less people
looking at such things, meaning more bugs get ignored.  Thus making
the issue worse.

So, when are you creating a replacement alsa-devel mailing list on
vger?  That's also subscribers-only.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
