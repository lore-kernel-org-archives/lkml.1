Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZCITq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZCITq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 15:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZCITqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 15:46:33 -0400
Received: from kroah.org ([198.145.64.141]:59446 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751597AbZCITqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 15:46:31 -0400
Date: Mon, 9 Mar 2009 12:41:32 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jouni Malinen <j@w1.fi>, Sujith <m.sujith@gmail.com>,
       Sujith <Sujith.Manoharan@atheros.com>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Christoph Hellwig <hch@infradead.org>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: Staging, place holder for better company/community development
	model
Message-ID: <20090309194132.GB15011@kroah.com>
References: <43e72e890903022314o44ae710u834d6207403fd4a2@mail.gmail.com> <1236514065.4205.9.camel@johannes.local> <20090308223304.GB11513@kroah.com> <1236583282.4205.71.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236583282.4205.71.camel@johannes.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 08:21:22AM +0100, Johannes Berg wrote:
> On Sun, 2009-03-08 at 15:33 -0700, Greg KH wrote:
> 
> > > FWIW, I would MUCH prefer if the staging crap never passed any official
> > > mailing lists.
> > 
> > What do you mean by this?  You don't ever want to see any staging
> > patches on any mailing lists?  That doesn't sound helpful.
> 
> Staging drivers will typically be an extremely huge amount of crap that
> just floods mailing lists. I don't care about those I don't read, but I
> would prefer to not have wireless staging drivers cross the wireless
> list which makes it seem like somebody is actually interested in those
> drivers.

I was asked by the wireless maintainer and some of the wireless
developers to send such patches to the list, so that everyone knows
exactly what is going on in the staging tree.

If you don't like this, then just ignore them.

> > I can provide a simple procmail rule if you really don't like this kind
> > of thing, but that seems pretty extreme...
> 
> I can very well filter on my own, thank you; I'm more worried about the
> noise for random third parties who then infer that this is something
> that somebody is working on and that might be useful to work on for
> them.  Neither of that is true for any wireless staging driver, they
> all require complete rewrites that can, imo, use the old code only for
> reference, not for implementation.

That's not true, some of them are being reworked as you type, to be a
"real" wireless driver eventually.

Incremental development over time is sometimes a good thing, instead of
total rewrites :)

thanks,

greg k-h
