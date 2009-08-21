Return-Path: <linux-kernel-owner+w=401wt.eu-S932920AbZHUVju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbZHUVju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932806AbZHUVjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:39:49 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42871 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800AbZHUVjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:39:48 -0400
Date: Fri, 21 Aug 2009 23:39:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, peterz@infradead.org,
       torvalds@linux-foundation.org, tytso@mit.edu, arjan@infradead.org,
       greg@kroah.com, mcgrof@gmail.com, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, corbet@lwn.net,
       sourcejedi.lkml@googlemail.com, andi@firstfloor.org
Subject: Re: [PATCH 00/14] kconfig: streamline distro configs for testers
Message-ID: <20090821213948.GB16210@merkur.ravnborg.org>
References: <20090819025634.987354707@goodmis.org> <20090820143025.7134930f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820143025.7134930f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 02:30:25PM -0700, Andrew Morton wrote:
> On Tue, 18 Aug 2009 22:56:34 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Here's my rebase of the prior push of streamline-config.pl.
> 
> ow, you made me look at perl code.
> 
> > The following patches are in:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > 
> >     branch: kconfig
> 
> Sam's been quiet lately.  I suggest that you add this to linux-next
> now so people get a chance to poke at it.

Busy at day time job so no spare time left for Linux stuff recently.
Will get back in a few weeks if we get the release out in time.

	Sam
