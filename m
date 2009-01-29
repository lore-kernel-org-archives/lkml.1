Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbZA2Qx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbZA2Qx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbZA2Qxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:53:44 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:61883 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZA2Qxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:53:42 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX184WgXQxofwZUuQQ7szfJQV
Date: Thu, 29 Jan 2009 08:53:35 -0800
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: OMAP clock fast-forward: an introduction to six series
Message-ID: <20090129165335.GI32148@atomide.com>
References: <alpine.DEB.2.00.0901281310590.14710@utopia.booyaka.com> <20090128211844.GI23301@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0901282357560.32081@utopia.booyaka.com> <20090129081117.GA11519@n2100.arm.linux.org.uk> <20090129083049.GB11519@n2100.arm.linux.org.uk> <20090129162556.GA32148@atomide.com> <20090129163501.GE18233@n2100.arm.linux.org.uk> <20090129164103.GD32148@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129164103.GD32148@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [090129 08:42]:
> * Russell King - ARM Linux <linux@arm.linux.org.uk> [090129 08:35]:
> > On Thu, Jan 29, 2009 at 08:25:58AM -0800, Tony Lindgren wrote:
> > > To me it does not matter which way the stuff gets merged. We just need
> > > to get it all merged.
> > > 
> > > If you guys can't get it merged and sorted out then it will all fall
> > > down on me. And then I have to use tools no smaller than a sledgehammer
> > > to merge it all, so the outcome won't be pretty!
> > 
> > Well, I've continued with my approach.  28 patches are currently merged
> > onto a follow-on branch (scattered throughout the series but in order)
> > and the result builds for my OMAP1, OMAP2 and OMAP3 test builds.
> 
> OK, only 32 more patches to go :)

I mean 42!

> > Patches which I've provided non-trivial comments on by and large haven't
> > been merged.  Once I've worked through the set, I'll provide a final list
> > of those outstanding so nothing should be lost.
> > 
> > I would appreciate someone _bouncing_ (not forwarding) the patches I'm
> > missing to linux@arm.linux.org.uk please.  Those being D6, E2 and F2.
> 
> I'll bounce them to you.
> 
> Regards,
> 
> Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
