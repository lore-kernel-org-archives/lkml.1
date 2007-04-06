Return-Path: <linux-kernel-owner+w=401wt.eu-S933386AbXDFXU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbXDFXU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933387AbXDFXU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:20:56 -0400
Received: from www.osadl.org ([213.239.205.134]:51470 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933386AbXDFXUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:20:55 -0400
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ...
	blinky leds!!)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: David Brownell <david-b@pacbell.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200704061557.12662.david-b@pacbell.net>
References: <11757099691323-git-send-email-tony@atomide.com>
	 <200704061405.50169.david-b@pacbell.net>
	 <1175897876.28263.490.camel@localhost.localdomain>
	 <200704061557.12662.david-b@pacbell.net>
Content-Type: text/plain
Date: Sat, 07 Apr 2007 01:21:22 +0200
Message-Id: <1175901682.28263.507.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Fri, 2007-04-06 at 15:57 -0700, David Brownell wrote:
> This particular issue doesn't actually affect indentation, since the
> tab trumps that space.  So it's a bit off-agenda for this particular
> flamage.

ROTFL, the tab trumps the space. Is this a card game ?

> > Please change your coding style to conform to Documentation/CodingStyle.
> > 
> >       ***     Only indent with tabs!!         ***

How does your own rule make SPACE-TAB-TAB more acceptable than
TAB-TAB-SPACE ? Just because TAB trumps the space but not the other way
round ?

You started nitpicking, so please accept the backfire.

	tglx

P.S: Please remove me from CC. I regret already, that I dragged myself
into this highly sophisticated and useful waste of electrons. I just had
that file opened in my favorite editor while I was skimming through
LKML.


