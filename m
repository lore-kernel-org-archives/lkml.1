Return-Path: <linux-kernel-owner+w=401wt.eu-S934307AbXG2TYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307AbXG2TYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 15:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932764AbXG2TYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 15:24:44 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57601 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765537AbXG2TYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 15:24:44 -0400
Date: Sun, 29 Jul 2007 21:25:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: ck@vds.kolivas.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       lkml@metanurb.dk
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Message-ID: <20070729192559.GA20961@uranus.ravnborg.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707291256.32769.Martin@lichtvoll.de> <20070729174239.GA20399@uranus.ravnborg.org> <200707292023.36555.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707292023.36555.Martin@lichtvoll.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 08:23:31PM +0200, Martin Steigerwald wrote:
> Am Sonntag 29 Juli 2007 schrieb Sam Ravnborg:
> > On Sun, Jul 29, 2007 at 12:56:28PM +0200, Martin Steigerwald wrote:
> > > Am Sonntag 29 Juli 2007 schrieb Sam Ravnborg:
> > > > > I
> > > > > actually also think that the communication between Ingo and Con
> > > > > could have been better especially when Ingo decided to write CFS
> > > > > while Con was still working hard on SD.
> > > >
> > > > You realize that Ingo posted his code for anyone to look at/comment
> > > > at about 48 hours after he started to work on CFS?
> > >
> > > Yes.
> >
> > So whats wrong then?
> > Ingo decides to do a better scheduler - to some extent inspired by
> > Con's work. And after 48 hours he publish first version that _anyone_
> > can see and comment on. Whats wrong with that?
> >
> > Did you expect some lengthy discussion before the coding phase started
> > or what?
> >
> > Just trying to understand what you are arguing about.
> 
> If I tried to rewrite a kernel subsystem - should I ever happen to dig 
> that deep into kernel matters - while I actually know that someone 
> already spent countless hours on exactly rewriting the exact same 
> subsystem, I think I would have told that other developer about it as 
> soon as I started coding on it.
The usual way to communicate such things on lkml are with patches as also
happened in this case.
It's not like Ingo had secretly developing a scheduler in parallel for
weeks or months but.
But I assume all the fuzz is about something else - it cannot be about
a these 48 hours - I hope..

Enough on this - back to work.

	Sam
