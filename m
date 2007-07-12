Return-Path: <linux-kernel-owner+w=401wt.eu-S932896AbXGLSlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbXGLSlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbXGLSlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:41:45 -0400
Received: from canuck.infradead.org ([209.217.80.40]:33151 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbXGLSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:41:45 -0400
Date: Thu, 12 Jul 2007 11:41:06 -0700
From: Greg KH <greg@kroah.com>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.22.1
Message-ID: <20070712184106.GA22849@kroah.com>
References: <20070710200637.GA5881@kroah.com> <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 11:35:41AM -0700, Nish Aravamudan wrote:
> On 7/10/07, Greg KH <greg@kroah.com> wrote:
> > We (the -stable team) are announcing the release of the 2.6.22.1 kernel.
> > It contains a security fix for SCTP that somehow forgot to be added to
> > the 2.6.22 kernel (was already released in the 2.6.21.y releases).
> > Thanks to Patrick McHardy for noticing the mistake.
> >
> > I'll also be replying to this message with a copy of the patch between
> > 2.6.22 and 2.6.22.1
> >
> > The updated 2.6.22.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
> 
> Can you please also update
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6-stable.git
> 
> ? Maybe make that update part of whatever process you use to push out
> the 2.6.Y trees, as I've had to ask for this more than once now?

That is a tree that Chris did, and I didn't realize we were maintaining
it as the "official" stable tree, that is why it is not mentioned in the
release notes :)

I'll let Chris decide if he wishes to maintain it or not, Chris?

thanks,

greg k-h
