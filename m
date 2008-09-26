Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYIZToz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYIZToz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYIZToq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:44:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:34255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbYIZToq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:44:46 -0400
Date: Fri, 26 Sep 2008 10:46:07 -0700
From: Greg KH <gregkh@suse.de>
To: Phil Hannent <phil@hannent.co.uk>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, mwilder@cs.nmsu.edu
Subject: Re: [PATCH] Input: add mmio xi driver
Message-ID: <20080926174607.GA700@suse.de>
References: <20080925232237.GA22938@suse.de> <20080925182055.f12f5d0b.randy.dunlap@oracle.com> <20080926031918.GA10083@suse.de> <48DCBEC3.2020904@hannent.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DCBEC3.2020904@hannent.co.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 11:51:47AM +0100, Phil Hannent wrote:
> Greg KH wrote:
> > On Thu, Sep 25, 2008 at 06:20:55PM -0700, Randy Dunlap wrote:
> >> On Thu, 25 Sep 2008 16:22:37 -0700 Greg KH wrote:
> >>
> >>> From: Greg Kroah-Hartman <gregkh@suse.de>
> >>>
> >>> This patch adds the Mimio Xi interactive whiteboard driver to the tree.
> >>>
> >>> It was originally written by mwilder@cs.nmsu.edu, but cleaned up and
> >>> forward ported by me to the latest kernel version.
> I have been given the protocol document for the whiteboards, I am not allowed to
> share it with anybody unfortunately.

That's great news, and not that big of a deal about the "no share" issue
as long as you are allowed to contribute.

> I am just waiting for approval of funds for me to start development of this
> driver and an X11 library to make the ink capture work.

Um, what's wrong with the driver that I just posted?  Does it not work
properly?  I'll gladly accept patches for things that are wrong, but
don't start over from scratch please.

> I expect to start work at the end of October, I could do with a mentor to help
> me with this.

If you need help on the kernel side, feel free to contact me off-list.

thanks,

greg k-h
