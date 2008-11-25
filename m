Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbYKYE5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbYKYE5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 23:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYKYE4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 23:56:54 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:35764 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbYKYE4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 23:56:52 -0500
X-Greylist: delayed 2211 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2008 23:56:52 EST
Date: Mon, 24 Nov 2008 21:19:35 -0700 (MST)
From: mwilder <mwilder@cs.nmsu.edu>
To: Greg KH <gregkh@suse.de>
cc: Phil Hannent <phil@hannent.co.uk>, Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] Input: add mmio xi driver
In-Reply-To: <20080926174607.GA700@suse.de>
Message-ID: <Pine.LNX.4.64.0811242028360.15284@gremlin.cs.nmsu.edu>
References: <20080925232237.GA22938@suse.de> <20080925182055.f12f5d0b.randy.dunlap@oracle.com>
 <20080926031918.GA10083@suse.de> <48DCBEC3.2020904@hannent.co.uk>
 <20080926174607.GA700@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.  I am the original developer of the mimio Xi driver for 2.4 
kernel linux. I have been observing this particular thread of emails for 
quite some time. I haven't been able to devote much attention to the 
developments in this thread because my primary research emphasis lies 
elsewhere.  Recent events, however, have provoked me to pay close 
attention to this thread.

I would like to thank gregkh@suse.de for his work folding in the 
2.6-specific mods to the driver.  This is something that I do not have the 
time to do, and I am glad to see that he has taken up the slack so 
that others may benefit from this work.

I would like to discuss the following dialog:

> On Fri, Sep 26, 2008 at 11:51:47AM +0100, Phil Hannent wrote:
> > Greg KH wrote:
> > > On Thu, Sep 25, 2008 at 06:20:55PM -0700, Randy Dunlap wrote:
> > >> On Thu, 25 Sep 2008 16:22:37 -0700 Greg KH wrote:
> > >>
> > >>> From: Greg Kroah-Hartman <gregkh@suse.de>
> > >>>
> > >>> This patch adds the Mimio Xi interactive whiteboard driver to the tree.
> > >>>
> > >>> It was originally written by mwilder@cs.nmsu.edu, but cleaned up and
> > >>> forward ported by me to the latest kernel version.
> > I have been given the protocol document for the whiteboards, I am not allowed to
> > share it with anybody unfortunately.
> 
> That's great news, and not that big of a deal about the "no share" issue
> as long as you are allowed to contribute.
> 
> > I am just waiting for approval of funds for me to start development of this
> > driver and an X11 library to make the ink capture work.
> 
> Um, what's wrong with the driver that I just posted?  Does it not work
> properly?  I'll gladly accept patches for things that are wrong, but
> don't start over from scratch please.
> 

> > I expect to start work at the end of October, I could do with a mentor to help
> > me with this.
> 
> If you need help on the kernel side, feel free to contact me off-list.
> 
>

What _is_ wrong with the driver?  I am guessing that phil@hannet.co.uk is 
just struggling with creating X bindings for the module, but I would like 
to hear some elaboration on what is actually happening here.  Enlighten 
me.



