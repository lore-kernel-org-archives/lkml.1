Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbZHTWOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbZHTWOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 18:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbZHTWOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 18:14:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642AbZHTWOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 18:14:52 -0400
Date: Thu, 20 Aug 2009 15:13:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org, tytso@mit.edu,
       arjan@infradead.org, greg@kroah.com, mcgrof@gmail.com,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org, sam@ravnborg.org,
       corbet@lwn.net, sourcejedi.lkml@googlemail.com, andi@firstfloor.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: Re: [PATCH 00/14] kconfig: streamline distro configs for testers
Message-Id: <20090820151326.b43038ce.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0908201741370.16405@gandalf.stny.rr.com>
References: <20090819025634.987354707@goodmis.org>
	<20090820143025.7134930f.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0908201741370.16405@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 17:43:38 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> > 
> > > The following patches are in:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > > 
> > >     branch: kconfig
> > 
> > Sam's been quiet lately.  I suggest that you add this to linux-next
> > now so people get a chance to poke at it.
> 
> I have no means of pushing into next. Would someone like to do a pull for 
> me?

If suitably bribed, Stephen will add you tree directly to the linux-nxt
lineup.

