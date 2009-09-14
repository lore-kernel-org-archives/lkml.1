Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbZINWGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbZINWGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZINWGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:06:44 -0400
Received: from kroah.org ([198.145.64.141]:37158 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbZINWGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:06:43 -0400
Date: Mon, 14 Sep 2009 15:04:43 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, arve@android.com,
       swetland@google.com, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Re: newer version of HTC Dream support
Message-ID: <20090914220443.GA20138@kroah.com>
References: <20090911075847.2fb7210a.randy.dunlap@oracle.com>
 <20090911161335.GA8137@elf.ucw.cz>
 <20090911092157.ba202b0a.randy.dunlap@oracle.com>
 <20090911212751.GA25544@elf.ucw.cz>
 <20090911153422.7d523a73.randy.dunlap@oracle.com>
 <20090913083719.GA6645@elf.ucw.cz>
 <20090914212413.GA10043@kroah.com>
 <20090914214619.GE10398@elf.ucw.cz>
 <20090914215131.GA2897@kroah.com>
 <20090914215443.GF10398@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914215443.GF10398@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 11:54:43PM +0200, Pavel Machek wrote:
> On Mon 2009-09-14 14:51:31, Greg KH wrote:
> > On Mon, Sep 14, 2009 at 11:46:19PM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > > > > Fix compilation of gpio_* input drivers on -next kernel. Adds needed
> > > > > > > headers and removes unprotected wakelock/earlysuspend dependencies.
> > > > > > >     
> > > > > > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > > > > 
> > > > > > Still doesn't build for me, but if it builds for you, that's great.
> > > > > > (could be a tool chain problem on my side)
> > > > > 
> > > > > No, it does not look like toolchain problem :-(. I had parts disabled
> > > > > in Kconfig. This should make it _compile_ (but not link); somehow
> > > > > MSM_ADSP is neccessary for camera to link and I can't see how to
> > > > > enable it.
> > > > > 
> > > > > Thanks for the patience.
> > > > 
> > > > Ugh, what patch should be applied in what order?  Care to resend them
> > > > with the proper "x/y" and a valid Subject: line?
> > > 
> > > All of patches are valid, and they should apply if you just "sort by
> > > date". I could dig them from my sent box...
> > 
> > Please resend them, their subjects need editing, and I want to make sure
> > I have them all.
> 
> You already applied the first one, right?

What is the "first" one?  Did you get an email saying I had applied it?

I have over 600 patches in the staging tree, it's hard to remember
specific ones...

thanks,

greg k-h
