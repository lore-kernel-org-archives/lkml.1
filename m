Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZKMR7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZKMR7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbZKMR73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:59:29 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:62261 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbZKMR72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:59:28 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19K8f+1iYAUl3tHqcmJRrCT
Date: Fri, 13 Nov 2009 09:59:28 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: ext Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "dedekind1@gmail.com" <dedekind1@gmail.com>
Subject: Re: [PATCH 00/19] OMAP: DSS2 v5 intro
Message-ID: <20091113175928.GB3684@atomide.com>
References: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
 <1257856848.21596.753.camel@localhost>
 <1257929140.20378.51.camel@tubuntu.research.nokia.com>
 <1257932641.20378.77.camel@tubuntu.research.nokia.com>
 <20091111184208.GC24837@atomide.com>
 <20091112161028.427787d9.sfr@canb.auug.org.au>
 <20091112181457.GX24837@atomide.com>
 <20091113074811.ee61948f.sfr@canb.auug.org.au>
 <1258106168.20378.119.camel@tubuntu.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258106168.20378.119.camel@tubuntu.research.nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@nokia.com> [091113 01:55]:
> Hi,
> 
> On Thu, 2009-11-12 at 21:48 +0100, ext Stephen Rothwell wrote:
> > Hi Tony, Tomi,
> > 
> > On Thu, 12 Nov 2009 10:14:57 -0800 Tony Lindgren <tony@atomide.com> wrote:
> > >
> > > OK. The only dependency is the the move of the headers.
> > > 
> > > Tomi, can you please rebase your patches on top of the "7xx-iosplit-plat-merge"
> > > branch in linux-omap tree? This is commit 8171d88089ad63fc442b2bf32af7c18653adc5cb,
> > > and it should stay static.
> > 
> > OK, *if* you (Tony) guarantee that the base is stable (i.e. never
> > rebased, but may have things added to it) and in linux-next, then I can
> > take the DSS2 stuff separately if you want me to.

Thanks. Yes, there should not be any need to rebase that commit.

> > Tomi, you can, of course, merge that branch into your tree instead of
> > rebasing on top of it (which ever is easiest).
> 
> I rebased DSS2 on top of 8171d88089ad63fc442b2bf32af7c18653adc5cb. It
> can be found from git://gitorious.org/linux-omap-dss2/linux.git for-next
> branch.
> 
> I'm ok with Tony pulling DSS2 to his next-branch, or Stephen pulling
> directly, which ever works easier for you.

I'd rather see Stephen pulling directly from Tomi, that's a good long
term solution for maintaining the DSS2 code.

Regards,

Tony
