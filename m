Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbZFMAbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbZFMAbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZFMAb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:31:28 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:48440 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750880AbZFMAb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:31:27 -0400
Date: Sat, 13 Jun 2009 01:30:16 +0100
From: Ben Dooks <ben@fluff.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Joe Perches <joe@perches.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       David Miller <davem@davemloft.net>, swetland@google.com, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090613003016.GB20442@fluff.org.uk>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk> <1244733310.895.60.camel@Joe-Laptop.home> <20090611182445.GA7658@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611182445.GA7658@uranus.ravnborg.org>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 08:24:45PM +0200, Sam Ravnborg wrote:
> On Thu, Jun 11, 2009 at 08:15:10AM -0700, Joe Perches wrote:
> > On Thu, 2009-06-11 at 13:38 +0100, Russell King - ARM Linux wrote:
> > > On Thu, Jun 11, 2009 at 05:00:30AM -0700, David Miller wrote:
> > > > From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> > > > Date: Thu, 11 Jun 2009 12:49:12 +0100
> > > > 
> > > > > I can not keep up with the number of patches that need to be
> > > > > reviewed and ultimately merged.  I know this, and I freely admit it,
> > > > > and I have done so on many occasions.
> > > > 
> > > > Then split up the responsibilities to other people instead of being
> > > > the choke point.  Controlling everything isn't so important.
> > > 
> > > Don't you think that I've been trying to get other people to be more
> > > involved?
> > > 
> > > - I've been pushing people to send patches to the relevent mailing
> > >   list(s) and maintainer(s) for years.
> > > 
> > > - I've been pushing people to send their ARM patches to the ARM
> > >   mailing list rather than directly into the patch system for review
> > >   (it even has a comment telling people this) so that others can get
> > >   involved in reviewing them, and sharing that work load.
> > > 
> > > Do you think either have been anywhere near successful?
> > []
> > > I've been trying to get greater participation
> > > but it's just not happening.
> > 
> > I suggest you stop using subscriber-only mailing lists and
> > use linux-arm@vger.kernel.org.
> 
> This is main point here is to offload Russell.
> One way to offload Russell is to have competent people reviewing platform
> code for ARM. This is best done by other platform people.
> Me and you - we can helpt. But the people where we need higher
> involvement are already on the list.

Personally, I'm not on linux-arm@vger.kernel.org and don't plan on
being there either. If people are too stupid to read the maintainers
entry and realise that linux-arm-kernel is moderated and they might
thus have to subscribe to post there then they can be safely ignored.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
