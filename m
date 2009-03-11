Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbZCKFD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbZCKFD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 01:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbZCKFDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 01:03:15 -0400
Received: from kroah.org ([198.145.64.141]:53811 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873AbZCKFDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 01:03:14 -0400
Date: Tue, 10 Mar 2009 22:00:18 -0700
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
Message-ID: <20090311050018.GB26202@kroah.com>
References: <43e72e890903022314o44ae710u834d6207403fd4a2@mail.gmail.com> <1236514065.4205.9.camel@johannes.local> <20090308223304.GB11513@kroah.com> <1236583282.4205.71.camel@johannes.local> <20090309194132.GB15011@kroah.com> <1236633633.9658.23.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236633633.9658.23.camel@johannes.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 10:20:33PM +0100, Johannes Berg wrote:
> On Mon, 2009-03-09 at 12:41 -0700, Greg KH wrote:
> 
> > > Staging drivers will typically be an extremely huge amount of crap that
> > > just floods mailing lists. I don't care about those I don't read, but I
> > > would prefer to not have wireless staging drivers cross the wireless
> > > list which makes it seem like somebody is actually interested in those
> > > drivers.
> > 
> > I was asked by the wireless maintainer and some of the wireless
> > developers to send such patches to the list, so that everyone knows
> > exactly what is going on in the staging tree.
> 
> This is a misrepresentation, a number of people have asked for this on
> specific drivers they are actively working on and that already are in
> usable shape.

Ok, so I'll be glad to not cc: the linux-wireless list if the maintainer
asks me to.

> > That's not true, some of them are being reworked as you type, to be a
> > "real" wireless driver eventually.
> > 
> > Incremental development over time is sometimes a good thing, instead of
> > total rewrites :)
> 
> Except it doesn't work for most of the wireless drivers you've sucked in
> without asking any wireless developers whether that makes any sense or
> not.

Any specific examples?

thanks,

greg k-h
