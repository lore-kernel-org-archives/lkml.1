Return-Path: <linux-kernel-owner+w=401wt.eu-S933077AbXGWLJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077AbXGWLJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 07:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760140AbXGWLI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 07:08:58 -0400
Received: from aug.linbit.com ([212.69.162.22]:33734 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760101AbXGWLI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 07:08:57 -0400
Date: Mon, 23 Jul 2007 13:08:53 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>, Kyle Moffett <mrlinuxman@mac.com>,
       Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>, drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070723110853.GA23495@mail.linbit.com>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	Christoph Hellwig <hch@infradead.org>,
	Kyle Moffett <mrlinuxman@mac.com>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>,
	drbd-user@lists.linbit.com
References: <20070721203819.GA10706@mail.linbit.com> <20070722213202.1f5d1cab.mrlinuxman@mac.com> <20070723084903.GA29443@infradead.org> <20070723090038.GA4996@uranus.ravnborg.org> <20070723090101.GA30305@infradead.org> <20070723091940.GC4996@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723091940.GC4996@uranus.ravnborg.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 11:19:40AM +0200, Sam Ravnborg wrote:
> The message is quite clear.
> For a driver like this do something like:
> - Describe the functionality / the problem is solved
> - Describe the overall design (maybe as a file in Documentation/?)

I'm currently writing the paper for linux-conf.eu,
and will make that available to you asap.

> - Make a single patch available

will do.

> - Submit mails in smaller chunks for on-the-list reviews
> 
> This will then be useable bot for the "triviality" reviewers like me
> and for the "knowledge able" reviewers like you.

will do.
now working on the remaining "triviality" issues already mentioned.

	Lars
