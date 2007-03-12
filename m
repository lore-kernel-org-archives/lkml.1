Return-Path: <linux-kernel-owner+w=401wt.eu-S1030427AbXCLPa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030427AbXCLPa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030430AbXCLPa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:30:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:47067 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030427AbXCLPa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:30:57 -0400
Date: Mon, 12 Mar 2007 08:29:20 -0700
From: Greg KH <greg@kroah.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
Message-ID: <20070312152920.GA29597@kroah.com>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45EB9DC6.8010403@rtr.ca> <45F56A2D.9010808@rtr.ca> <200703121606.06601.oneukum@suse.de> <45F56E37.9050506@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F56E37.9050506@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 11:13:59AM -0400, Mark Lord wrote:
> Oliver Neukum wrote:
> >Am Montag, 12. M??rz 2007 15:56 schrieb Mark Lord:
> >>Still no improvement on the b0rken usb-serial resume support in -rc*.
> >
> >Have you applied the fixes in Greg's current tree?
> 
> I don't know anything about any "current tree"
> other than the 2.6.21-rc3-git* on kernel.org.

And all of those fixes Oliver is referring to should be in anything
older than 2.6.21-rc3-git6.  So we have a different problem here than
what people were seeing before.

> Greg hasn't suggested anything for this yet,
> mostly because he's been busy keeping the 2.6.20.xx
> point releases sane.

No, I didn't suggest anything because I thought it was going to be fixed
with Oliver's patches :(

thanks,

greg k-h
