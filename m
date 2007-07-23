Return-Path: <linux-kernel-owner+w=401wt.eu-S1762257AbXGWItW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257AbXGWItW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbXGWItO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:49:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35162 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbXGWItN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:49:13 -0400
Date: Mon, 23 Jul 2007 09:49:03 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Kyle Moffett <mrlinuxman@mac.com>
Cc: Lars Ellenberg <lars@linbit.com>, Jens Axboe <axboe@kernel.dk>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>,
       drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070723084903.GA29443@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Kyle Moffett <mrlinuxman@mac.com>, Lars Ellenberg <lars@linbit.com>,
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
	lkml <linux-kernel@vger.kernel.org>, drbd-user@linbit.com
References: <20070721203819.GA10706@mail.linbit.com> <20070722213202.1f5d1cab.mrlinuxman@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722213202.1f5d1cab.mrlinuxman@mac.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 09:32:02PM -0400, Kyle Moffett wrote:
> First of all, if you could break this up into chunks (even if they
> aren't useful individually) just to make it easier to review.

No, please don't do that I have no idea why people say that except for
drinking too much "small patches" koolaid.  Small patches are the
most optimal form if you can split patches logically.  There is absolutely
no point in splitting up a large driver into multiple patches.  It just
means you have to download and apply all of them to get the global picture
needed for a proper review again.  If a driver is too large for lkml a
pointer to a large patch is much much better for a proper review.

