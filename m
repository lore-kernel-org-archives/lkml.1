Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYEHG2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYEHG2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYEHG2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:28:38 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52733 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449AbYEHG2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:28:36 -0400
Date: Thu, 8 May 2008 09:27:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: the purge :-)
Message-ID: <20080508062715.GE14951@cs181133002.pp.htv.fi>
References: <20080508112130.fd574b50.sfr@canb.auug.org.au> <20080508042753.GA6876@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080508042753.GA6876@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 09:27:53PM -0700, Greg KH wrote:
> On Thu, May 08, 2008 at 11:21:30AM +1000, Stephen Rothwell wrote:
> > Greg, you might consider setting up a subset (currently probably
> > empty) of the ldp tree for drivers that are readier for integration.
> 
> Ok, fair enough, I totally understand.
> 
> I've now moved my trees around a bit, and would like it if you could
> include the following, in this order (the # NEXT_BASE variable is set in
> them to make sure things get ordered properly.)
> 	driver-core.next
> 	usb.next
> 	driver-core
> 	usb
> 	ldp.next
> 
> The ".next" trees are what is going to Linus before the next major
> release happens (bugfixes and new device ids at this point in time for
> example.)  The other trees are what is going to go to Linus after the
> next major kernel is out.
>...

So the "next" in your .next has the opposite meaning of the one in 
linux-next?

Can you name it .fixes instead to make it clearer?

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

