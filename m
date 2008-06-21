Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbYFUSDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbYFUSDB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 14:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYFUSCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 14:02:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51467 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYFUSCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 14:02:49 -0400
Subject: Re: How linux-staging is released (was Re:
	linux-staging/linux-next merge/build errors)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080621175003.GC14786@kroah.com>
References: <20080621124017.ec3b0a51.sfr@canb.auug.org.au>
	 <20080621071956.GB2765@kroah.com>
	 <1214053209.3223.220.camel@lappy.programming.kicks-ass.net>
	 <20080621175003.GC14786@kroah.com>
Content-Type: text/plain
Date: Sat, 21 Jun 2008 20:02:22 +0200
Message-Id: <1214071343.3223.249.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-21 at 10:50 -0700, Greg KH wrote:
> On Sat, Jun 21, 2008 at 03:00:08PM +0200, Peter Zijlstra wrote:
> > 
> > So what motivates people to keep working on items in your tree if
> > distros are already shipping their stuff?
> 
> The fact that the code still isn't upstream?
> 
> And I'm not betting on distros picking this tree up, but it is in an
> easy form if they wish to do so :)

The point was that for some people being carried by distos is upstream
enough.

So I would discourage distros form picking up this tree.

The scenario I was thinking about is some HW vendor writing a shitty
driver, dumping it in your tree - getting picked up by $DISTRO and
saying, job done, people can use it. Leaving you to pick up the pieces -
which, with you not having hw-docs, is a hard job.

> > Will you drop drivers that stagnate?
> 
> Heh, most of the drivers are in my tree because they were stagnating
> somewhere else :)
> 
> Hopefully no, it's trivial to drag them along forever, but I'll be
> working to get them upstream as fast as I can, and it also provides a
> very nice project for someone to pick up and work on, as a number of
> developers already have.

Good stuff ;-)

