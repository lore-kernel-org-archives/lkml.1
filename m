Return-Path: <linux-kernel-owner+w=401wt.eu-S1764605AbYBNSmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764605AbYBNSmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331AbYBNSmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:42:11 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:47626 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbYBNSmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:42:09 -0500
Date: Thu, 14 Feb 2008 13:32:02 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
In-reply-to: <alpine.LFD.1.00.0802140949460.6110@woody.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org
Message-id: <200802141332.03315.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
 <20080214232229.f7bdc6ac.sfr@canb.auug.org.au>
 <alpine.LFD.1.00.0802140949460.6110@woody.linux-foundation.org>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008, Linus Torvalds wrote:
[...]
>And this is where "process" really matters. Making sure people don't get
>too frustrated about the constant grind.

One of the problems caused by this 'grind' is being locked out of using 3rd 
party closed drivers until the vendor decides its stable enough to make the 
effort to update their binary blobs to match the newer functions.

Nvidia vs 2.6.25-rc1 being a case in point, and they (nvidia) are appearing to 
indicate its not a problem until some distro actually ships a kernel with the 
changes that broke it.  That could be months or even a year plus.

So you've lost one 'canary in the coal mine' tester at least until that 
happens as I don't have a spare box I can setup to run the nv driver, which 
itself seems to be suffering from bit rot recently and cannot run this screen 
at its native 1680x1050 resolution, reverting to something that resembles 
what I used to get from a timex 1000 in 1978 but with a few colors.  I just 
recently had to install the nvidia driver on my milling machines kubuntu 6.06 
box cuz an xorg update put it back to 640x400 if the nv driver was used.  
This is the real world, where politics aside, it just has to work... :-(

But I'll still be lurking and building to test anyway even if I don't boot it 
for more than 10 minutes. :)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I'm not a lawyer. I don't even play one on TV.

	- Linus Torvalds on the gcc mailing list
