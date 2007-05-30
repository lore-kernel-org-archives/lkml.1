Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbXE3N3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbXE3N3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXE3N3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:29:47 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53716 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbXE3N3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:29:46 -0400
Date: Wed, 30 May 2007 15:30:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bryan Wu <bryan.wu@analog.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] Blackfin update for 2.6.22-rc3
Message-ID: <20070530133042.GA14693@uranus.ravnborg.org>
References: <11803414753217-git-send-email-bryan.wu@analog.com> <alpine.LFD.0.98.0705291356290.26602@woody.linux-foundation.org> <200705300909.13419.rgetz@blackfin.uclinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705300909.13419.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 09:09:13AM -0400, Robin Getz wrote:
> On Tue 29 May 2007 16:59, Linus Torvalds pondered:
> > 
> > On Mon, 28 May 2007, Bryan Wu wrote:
> > > 
> > >  - Blackfin arch update including BF54x initial supporting
> > >  - Blackfin driver update: serial/spi/rtc
> > >  - Provide new Blackfin watchdog driver
> > >  - binfmt_flat.c for Blackfin arch modification
> > 
> > I realize that this all just touches blackfin-specific stuff, but after 
> > -rc3 I really prefer not to bother with these things..
> > 
> > Also, for stuff that is really just an architecture that I can't even 
> > test,
> 
> In one of my (how did Andrew word it...) circumlocutious threads about 
> Blackfin a while ago, I offered hardware to anyone who wanted to try things 
> out.
Any possibility for you to provide cross-toolchain for x86?
I have no plans running on actual HW but adding a bit more compile coverage would be great.

	Sam
