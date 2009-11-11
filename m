Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbZKKSmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbZKKSmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 13:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbZKKSmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 13:42:12 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:51549 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125AbZKKSmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 13:42:11 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/kVxLrU50KeuhD+mlkbtk4
Date: Wed, 11 Nov 2009 10:42:09 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "dedekind1@gmail.com" <dedekind1@gmail.com>
Subject: Re: [PATCH 00/19] OMAP: DSS2 v5 intro
Message-ID: <20091111184208.GC24837@atomide.com>
References: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
 <1257856848.21596.753.camel@localhost>
 <1257929140.20378.51.camel@tubuntu.research.nokia.com>
 <1257932641.20378.77.camel@tubuntu.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257932641.20378.77.camel@tubuntu.research.nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@nokia.com> [091111 01:43]:
> On Wed, 2009-11-11 at 09:45 +0100, Valkeinen Tomi (Nokia-D/Helsinki)
> wrote:
> > On Tue, 2009-11-10 at 13:40 +0100, Artem Bityutskiy wrote:
> > > Tomi,
> > > 
> > > could you please kindly ask Stephen (CCed) to include the DSS2 tree into
> > > linux-next, because you are going to merge it the next merge window, and
> > > there does not seem to be any blocker for this.
> > > 
> > > Being in linux-next for a while is really important.
> > 
> > Stephen, would this be possible? DSS2 driver is rather big piece of
> > code, even if it's quite isolated, so it would be nice to have it in
> > linux-next.
> > 
> > What does it require from me? A git tree, obviously, but what should it
> > be based on?
> 
> Ah, I just realized that DSS2 patches depend on patches from Tony's
> tree. I guess I should base my tree on top of some Tony's tree that is
> going to linux-next?

Or I can merge them into my for-next if that's OK with everybody. This
merge cycle is a pain for omap as we've moved all the common headers from
include/mach to include/plat.

Tomi should still send a separate pull request for Linus for the
DSS2 patches.

Regards,

Tony
