Return-Path: <linux-kernel-owner+w=401wt.eu-S1763038AbXGXD2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763038AbXGXD2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 23:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbXGXD2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 23:28:07 -0400
Received: from ozlabs.org ([203.10.76.45]:59257 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbXGXD2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 23:28:06 -0400
Subject: Re: [PATCH 1/7] lguest: documentation pt I: Preparation
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rob Landley <rob@landley.net>
In-Reply-To: <20070723200617.87507f16.rdunlap@xenotime.net>
References: <1184980678.6344.1.camel@localhost.localdomain>
	 <20070723171238.1a832b31.akpm@linux-foundation.org>
	 <20070723192113.0eaa0ad8.rdunlap@xenotime.net>
	 <20070723200617.87507f16.rdunlap@xenotime.net>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 13:27:39 +1000
Message-Id: <1185247659.1803.130.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 20:06 -0700, Randy Dunlap wrote:
> On Mon, 23 Jul 2007 19:21:13 -0700 Randy Dunlap wrote:
> > It's great that Rusty took the time to produce all of this documentation.
> > Few people do that today.

Thanks Randy, it was something of an experiment.  We'll see if it has
the desired effect (ie. encouraging new hackers).

> Neat as that is, I'm concerned that it will be difficult to maintain
> (the order numbers at least -- or are they just difficult to set up
> the first time?).

Setup was a pain, but maintenance hasn't been too bad.  Most changes
don't deeply alter the code structure.  After major surgery I diff the
documentation output to check I haven't broke anything major (eg.
removed a title or a section terminator).

> Advantage:  it does keep the source code + doc text together.
> Martin (former kernel-doc maintainer) was going to come up with
> some way to do this, but he abandoned it.

Yeah, code documentation like this belongs in comments IMHO, and even
there it can rot.

Thanks,
Rusty.

