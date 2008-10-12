Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbYJLEES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbYJLEES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 00:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbYJLEEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 00:04:12 -0400
Received: from kroah.org ([198.145.64.141]:60580 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750757AbYJLEEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 00:04:10 -0400
Date: Sat, 11 Oct 2008 21:02:23 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.27 will be a longtime supported kernel
Message-ID: <20081012040223.GC18221@kroah.com>
References: <alpine.LFD.2.00.0810091651220.3210@nehalem.linux-foundation.org> <20081011210340.GA11198@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011210340.GA11198@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 12:03:40AM +0300, Adrian Bunk wrote:
> 2.6.16 has become a bit dated, and I'll maintain 2.6.27 for a few years 
> as a replacement.

Hm, you're not the only one going to be doing this, there are at least
three distros basing their latest releases on this kernel :)

> As with 2.6.16, I'll pickup maintainance when the normal -stable 
> maintainance ends (at some point after 2.6.28 gets released in January).

I was considering hanging on to .27 for a while longer than the .28
release, much like .25 has been working out.  But probably some time
after .29 I'll be glad to hand it off to you for you to maintain like
.16 was.  Is that ok?

> It is intended to fill the niche for users who are not using 
> distribution kernels but want to use a regression-free kernel for a 
> longer time. It might be a small part of the userbase, but after the 
> experiences with 2.6.16 I can say that there are quite a few users
> who appreciate such an offering.

Hey, I personally liked it as it made maintaining SLES a lot easier,
thanks a lot for your work there!

thanks,

greg k-h
