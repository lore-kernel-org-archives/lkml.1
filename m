Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZFAVXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZFAVXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZFAVXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:23:15 -0400
Received: from waste.org ([66.93.16.53]:37289 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZFAVXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:23:15 -0400
Subject: Re: [PATCH] update kernel's scripts/bloat-o-meter from busybox
From: Matt Mackall <mpm@selenic.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier@gentoo.org>
In-Reply-To: <200906011657.20251.rgetz@blackfin.uclinux.org>
References: <200906011526.01108.rgetz@blackfin.uclinux.org>
	 <1243885732.22069.112.camel@calx>
	 <200906011657.20251.rgetz@blackfin.uclinux.org>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 16:17:20 -0500
Message-Id: <1243891040.22069.117.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 16:57 -0400, Robin Getz wrote:
> On Mon 1 Jun 2009 15:48, Matt Mackall pondered:
> > On Mon, 2009-06-01 at 15:26 -0400, Robin Getz wrote:
> > > From: "Rob Landley" <rob@landley.net>
> > > From: "Denis Vlasenko" <vda.linux@googlemail.com>
> > > From: "Bernhard Reutner-Fischer" <rep.dot.nop@gmail.com>
> > > 
> > > Since bloat-o-meter was added to the kernel's source tree, it has
> > > received little attention - either it works really well - or no
> > > one uses it. I suspect the first :)
> > > 
> > > However - some folks who have been using it more (mainly as part 
> > > of busybox) have been poking at it more often - and the output is
> > > a little more friendly  now.
> > > 
> > > http://git.busybox.net/busybox/log/scripts/bloat-o-meter
> > > 
> > > I think Rob had been sending early patches both places, but
> > > somewhere along the line things never made it to lkml.
> > 
> > I probably dropped them on the ground during a busy spell.
> 
> Sorry - I didn't mean to sound like I was trying to blame anyone. 

And I'm just making sure Rob doesn't feel blamed. He did send me
patches, and they didn't go anywhere.

I can do a round of make-it-idiomatic-python after we get this merged,
that'll probably be more efficient than me picking nits.

-- 
http://selenic.com : development and support for Mercurial and Linux


