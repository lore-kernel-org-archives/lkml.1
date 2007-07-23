Return-Path: <linux-kernel-owner+w=401wt.eu-S933726AbXGWI7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726AbXGWI7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbXGWI7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:59:25 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49626 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbXGWI7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:59:24 -0400
Date: Mon, 23 Jul 2007 11:00:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>, Kyle Moffett <mrlinuxman@mac.com>,
       Lars Ellenberg <lars@linbit.com>, Jens Axboe <axboe@kernel.dk>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>,
       drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070723090038.GA4996@uranus.ravnborg.org>
References: <20070721203819.GA10706@mail.linbit.com> <20070722213202.1f5d1cab.mrlinuxman@mac.com> <20070723084903.GA29443@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723084903.GA29443@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 09:49:03AM +0100, Christoph Hellwig wrote:
> On Sun, Jul 22, 2007 at 09:32:02PM -0400, Kyle Moffett wrote:
> > First of all, if you could break this up into chunks (even if they
> > aren't useful individually) just to make it easier to review.
> 
> No, please don't do that I have no idea why people say that except for
> drinking too much "small patches" koolaid.

It is much more preferred to have code available in the mailer than
being forced to copy it from some big patch somewhere when you
want to point out something.

Obviously the big picture is needed too. But the introductory mail
describing the overall design and functionality should provide most of this.
This submission obviously also failed to provide such an overall design intro.

> If a driver is too large for lkml a
> pointer to a large patch is much much better for a proper review.
Then we should request both...

	Sam
