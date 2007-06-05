Return-Path: <linux-kernel-owner+w=401wt.eu-S1764794AbXFERWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764794AbXFERWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbXFERWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:22:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:58621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbXFERWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:22:22 -0400
Date: Tue, 5 Jun 2007 10:14:17 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net,
       "art@usfltd.com" <art@usfltd.com>, Oliver Neukum <oneukum@suse.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Jiri Kosina <jikos@jikos.cz>,
       Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       Ioan Ionita <opslynx@gmail.com>
Subject: Re: [5/5] 2.6.22-rc4: known regressions
Message-ID: <20070605171417.GA16417@suse.de>
References: <46657407.1000108@googlemail.com> <466576B9.2080203@googlemail.com> <20070605164933.GA23544@suse.de> <6bffcb0e0706051002q1a24f94fwde388493cd5fd3c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0706051002q1a24f94fwde388493cd5fd3c1@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 07:02:53PM +0200, Michal Piotrowski wrote:
>  On 05/06/07, Greg KH <gregkh@suse.de> wrote:
> > On Tue, Jun 05, 2007 at 04:44:09PM +0200, Michal Piotrowski wrote:
> > >
> > >  Subject    : usb hotplug/udev cannot correctly register usb/scanners
> > >  References : http://lkml.org/lkml/2007/5/15/205
> > >  Submitter  : art@usfltd.com <art@usfltd.com>
> > >  Status     : Unknown
> >
> >
> > Art seems to not be responding anymore, so I would mark this as
> > "unreproducable" :(
> 
>  Do anyone else have this problem?
>  (I can't find anything similar to this)

I have not heard of anyone else reporting this problem either.

thanks,

greg k-h
