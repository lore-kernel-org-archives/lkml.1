Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZHTVnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZHTVnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZHTVnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:43:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61151 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZHTVnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:43:40 -0400
Date: Thu, 20 Aug 2009 17:43:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org, tytso@mit.edu,
       arjan@infradead.org, greg@kroah.com, mcgrof@gmail.com,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org, sam@ravnborg.org,
       corbet@lwn.net, sourcejedi.lkml@googlemail.com, andi@firstfloor.org
Subject: Re: [PATCH 00/14] kconfig: streamline distro configs for testers
In-Reply-To: <20090820143025.7134930f.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0908201741370.16405@gandalf.stny.rr.com>
References: <20090819025634.987354707@goodmis.org> <20090820143025.7134930f.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 20 Aug 2009, Andrew Morton wrote:

> On Tue, 18 Aug 2009 22:56:34 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Here's my rebase of the prior push of streamline-config.pl.
> 
> ow, you made me look at perl code.

What? Pearls are gentle on the eyes. Much better than looking at snakes.

> 
> > The following patches are in:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > 
> >     branch: kconfig
> 
> Sam's been quiet lately.  I suggest that you add this to linux-next
> now so people get a chance to poke at it.

I have no means of pushing into next. Would someone like to do a pull for 
me?

-- Steve

