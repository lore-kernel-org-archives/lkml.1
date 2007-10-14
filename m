Return-Path: <linux-kernel-owner+w=401wt.eu-S1763539AbXJNVP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763539AbXJNVP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbXJNVPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:15:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55658 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759532AbXJNVPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:15:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: Regression:  2.6.23-rc9 okay, 2.6.23.1 resume problems
Date: Sun, 14 Oct 2007 23:30:37 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <4712786B.3040009@rtr.ca>
In-Reply-To: <4712786B.3040009@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710142330.38057.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 14 October 2007 22:13, Mark Lord wrote:
> Since upgrading to 2.6.23.1 from 2.6.23-rc9, resume-from-RAM has been misbehaving here.
> 
> It takes much (+5-7 seconds) longer to resume *sometimes*, but not all/most of the time.
> And sometimes I get get flashing keyboard LEDs and have to hold the power button
> in for a full hard reset.
> 
> With 2.6.23-rc8/rc9, no such troubles.
> 
> Difficult to reproduce, other than perhaps once a day.
> Anybody want to fess up with a likely candidate?

Not really, but if you rule out all of the POWERPC and MIPS patches, there's
not much left ...

Greetings,
Rafael
