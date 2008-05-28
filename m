Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbYE1WyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbYE1WyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 18:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYE1Wx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 18:53:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49680 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbYE1Wx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 18:53:57 -0400
Date: Wed, 28 May 2008 15:51:36 -0700
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Message-ID: <20080528225136.GA29014@kroah.com>
References: <1211995212.3445.52.camel@localhost.localdomain> <1212007760.2236.17.camel@shinybook.infradead.org> <1212008517.3445.89.camel@localhost.localdomain> <84144f020805281431y1aac903am442b333a2a13cd15@mail.gmail.com> <1212010931.3445.103.camel@localhost.localdomain> <1212013125.2236.58.camel@shinybook.infradead.org> <1212014127.3445.115.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212014127.3445.115.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 05:35:27PM -0500, James Bottomley wrote:
> On Thu, 2008-05-29 at 01:18 +0300, David Woodhouse wrote:
> > On Wed, 2008-05-28 at 16:42 -0500, James Bottomley wrote:
> > > Appeals to be politer tend to only work in the short term (having given
> > > quite a few of them).  I think we're developing a root cause problem in
> > > the way we recruit people to work in the kernel and we have to think
> > > about fixing it there.
> > 
> > Do we really have a problem recruiting people to work in the kernel? On
> > what do you base that observation?
> 
> Yes, the median age of the MAINTAINERS is rising.  Not quite at the rate
> of a year per year which would show we have practically no turn over,
> but it is rising.

My raw numbers show that the number of individual kernel contributors
continues to increase with every release, so this might not be as much
of a problem as it's made out to be.

> However, even if there were no recruitment problem at all, getting more
> people involved is always better because it means more contributions.
> And contributions (useful ones) are the lifeblood that moves the kernel
> forwards.

I agree.

thanks,

greg k-h
