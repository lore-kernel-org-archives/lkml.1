Return-Path: <linux-kernel-owner+w=401wt.eu-S965928AbXJPXvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965928AbXJPXvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbXJPXvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:51:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38068 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbXJPXvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:51:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: Regression:  2.6.23-rc9 okay, 2.6.23.1 resume problems
Date: Wed, 17 Oct 2007 02:07:02 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <4712786B.3040009@rtr.ca> <47128C2C.5060502@rtr.ca> <471536E2.9040508@rtr.ca>
In-Reply-To: <471536E2.9040508@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710170207.02732.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 17 October 2007 00:10, Mark Lord wrote:
> Mark Lord wrote:
> > Rafael J. Wysocki wrote:
> >> On Sunday, 14 October 2007 22:13, Mark Lord wrote:
> >>> Since upgrading to 2.6.23.1 from 2.6.23-rc9, resume-from-RAM has been 
> >>> misbehaving here.
> >>>
> >>> It takes much (+5-7 seconds) longer to resume *sometimes*, but not 
> >>> all/most of the time.
> >>> And sometimes I get get flashing keyboard LEDs and have to hold the 
> >>> power button
> >>> in for a full hard reset.
> >>>
> >>> With 2.6.23-rc8/rc9, no such troubles.
> >>>
> >>> Difficult to reproduce, other than perhaps once a day.
> >>> Anybody want to fess up with a likely candidate?
> >>
> >> Not really, but if you rule out all of the POWERPC and MIPS patches, 
> >> there's
> >> not much left ...
> > 
> > Yeah, I didn't see much there either.
> > 
> > I'll keep an eye on things over the next few days,
> > and post again if it persists.
> > 
> > I was using the powertop patches with -rc9, but not with 2.6.23.1.
> > Maybe they helped (???).
> 
> It still happens.

Well, I have no idea, sorry.

I also have not been able to reproduce it here ...
