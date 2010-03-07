Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0CGUy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 15:54:27 -0500
Received: from netrider.rowland.org ([192.131.102.5]:55635 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751391Ab0CGUy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 15:54:26 -0500
Date: Sun, 7 Mar 2010 15:54:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: The gregkh patch scripts
In-Reply-To: <20100307181649.GD3718@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1003071546000.8502-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Mar 2010, Greg KH wrote:

> Yes, I can switch back to going off of the -rcN-gitM markings that I was
> using in the past.  If I do that does it make it easier for you?
> 
> And yes, you are right, this is a constant rebase, and that's wrong on
> my part.

That's exactly the problem.  I don't mind rebasing for each -rcN; in
fact many of the early -rc kernels often contain important bug fixes so
I'm glad to have them.  But rebasing more often than that becomes
increasingly inconvenient.

> This makes me reconsider the fact that I'm using quilt for all of this.
> Perhaps if I switch to a git tree, it would all be easier for people
> like you?  Would you prefer that?

I'm happy either way (although by now I'm quite used to using quilt and
not so accustomed to git -- I haven't tried guilt).  Of course, other
people may feel differently.

> For stuff like my staging tree, I'm almost convinced that switching to
> git makes more sense as keeping that many patches in quilt is a mess and
> I don't ever end up rebasing anything or deleting any patches in the
> middle anymore.
> 
> For USB, yeah, I think it's also time to switch over as well.  What do
> you think?

Let's ask some other people on the USB list (CC'ed).  My main concern 
is to avoid rebasing too often, whichever source-code management system 
is used.

Alan Stern

