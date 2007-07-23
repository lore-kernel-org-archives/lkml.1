Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbXGWJBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbXGWJBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 05:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbXGWJBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 05:01:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45102 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbXGWJBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 05:01:04 -0400
Date: Mon, 23 Jul 2007 10:01:01 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>, Kyle Moffett <mrlinuxman@mac.com>,
       Lars Ellenberg <lars@linbit.com>, Jens Axboe <axboe@kernel.dk>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>,
       drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070723090101.GA30305@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Sam Ravnborg <sam@ravnborg.org>, Kyle Moffett <mrlinuxman@mac.com>,
	Lars Ellenberg <lars@linbit.com>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>,
	drbd-user@linbit.com
References: <20070721203819.GA10706@mail.linbit.com> <20070722213202.1f5d1cab.mrlinuxman@mac.com> <20070723084903.GA29443@infradead.org> <20070723090038.GA4996@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723090038.GA4996@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 11:00:38AM +0200, Sam Ravnborg wrote:
> On Mon, Jul 23, 2007 at 09:49:03AM +0100, Christoph Hellwig wrote:
> > On Sun, Jul 22, 2007 at 09:32:02PM -0400, Kyle Moffett wrote:
> > > First of all, if you could break this up into chunks (even if they
> > > aren't useful individually) just to make it easier to review.
> > 
> > No, please don't do that I have no idea why people say that except for
> > drinking too much "small patches" koolaid.
> 
> It is much more preferred to have code available in the mailer than
> being forced to copy it from some big patch somewhere when you
> want to point out something.

While that's a valid point I totally agree on for small patches it just
doesn't matter for a complex driver where you need to sit down for an
hour or more to actually do a useful review.

