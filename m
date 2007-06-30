Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbXF3VJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbXF3VJf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 17:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXF3VJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 17:09:27 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48909 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbXF3VJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 17:09:27 -0400
Date: Sat, 30 Jun 2007 23:10:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
Message-ID: <20070630211017.GA26234@uranus.ravnborg.org>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <6150.1183128630@turing-police.cc.vt.edu> <20070629140130.59d58c44.akpm@linux-foundation.org> <15437.1183177066@turing-police.cc.vt.edu> <20070629221510.95c4c8e1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629221510.95c4c8e1.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 10:15:10PM -0700, Andrew Morton wrote:
> On Sat, 30 Jun 2007 00:17:46 -0400 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Fri, 29 Jun 2007 14:01:30 PDT, Andrew Morton said:
> > > On Fri, 29 Jun 2007 10:50:30 -0400
> > > Valdis.Kletnieks@vt.edu wrote:
> > 
> > > > Odd - just for grins, I checked what 'make oldconfig' did when handed a .config
> > > > from 22-rc4-mm2, and it behaved just fine, much to my surprise.
> > > 
> > > That's probably because your old config file was relatively recent, and
> > > had things like CONFIG_BLK_DEV=y in it.
> > 
> > Ahh... <light bulb goes on> Yeah, it gets a 'make oldconfig' for pretty
> > much every single -mm, I suck at any regression testing other than "since
> > the last -mm".
> > 
> 
> All my .configs have mouldered since I lost the ability to have .config be
> a symlink to a revision-controlled file (used to carry a custom patch for
> this, but it died).
> 
> I continue to believe that kbuild's lets-trash-your-symlink behaviour is
> obnoxious, but I was unable to persuade anyone else of this.

I thought we fixed that long time ago?!?!
I am heading for vacation for 20 days without Internet (real vacation :-))
and have properly forget most about Linux and everything about this
issue when I return.
In the unlikely event that I recall it I will take a look when I'm back.

By the way - kbuild.git is lacking behind on patches.
I have several queded from other peopel and have more in the works myself.
This will not be looked into until I'm back.

	Sam
