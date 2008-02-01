Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbYBAWcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbYBAWcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbYBAWb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:31:59 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:39970 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497AbYBAWb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:31:58 -0500
Date: Fri, 1 Feb 2008 23:32:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Are Section mismatches out of control?
Message-ID: <20080201223201.GA17828@uranus.ravnborg.org>
References: <20080201104718.GA11717@uranus.ravnborg.org> <20080201030329.9b760777.akpm@linux-foundation.org> <1201864894.23523.117.camel@brick> <Pine.LNX.4.64.0802011325080.18111@anakin> <20080201134041.GC13349@uranus.ravnborg.org> <Pine.LNX.4.64.0802012221400.28712@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802012221400.28712@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 10:22:13PM +0100, Geert Uytterhoeven wrote:
> On Fri, 1 Feb 2008, Sam Ravnborg wrote:
> > On Fri, Feb 01, 2008 at 02:30:44PM +0100, Geert Uytterhoeven wrote:
> > > BTW, on m68k I get ca. 160 of them. Most seem to originate in
> > > drivers/isdn/. Doesn't look unsurmountable compared to the number of
> > > other compile warnings fixed during the last few years ;-)
> > 
> > Can you try the patchset I will post in a minute.
> > Would be nice to know if you see additional warnings as I got
> > isdn clean here with x86 - 64 bit - allyesconfig.
> 
> Sure. Where can I find that patchset? I didn't see it on lkml so far,
> except for the [0/5] email.

I posted a cumulative patch-set which you can find here:
http://lkml.org/lkml/2008/2/1/242

	Sam
