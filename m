Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbYFURxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbYFURxk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 13:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYFURxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 13:53:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39672 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYFURxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 13:53:30 -0400
Date: Sat, 21 Jun 2008 10:50:03 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: How linux-staging is released (was Re:
	linux-staging/linux-next merge/build errors)
Message-ID: <20080621175003.GC14786@kroah.com>
References: <20080621124017.ec3b0a51.sfr@canb.auug.org.au> <20080621071956.GB2765@kroah.com> <1214053209.3223.220.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214053209.3223.220.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 03:00:08PM +0200, Peter Zijlstra wrote:
> 
> So what motivates people to keep working on items in your tree if
> distros are already shipping their stuff?

The fact that the code still isn't upstream?

And I'm not betting on distros picking this tree up, but it is in an
easy form if they wish to do so :)

> Will you drop drivers that stagnate?

Heh, most of the drivers are in my tree because they were stagnating
somewhere else :)

Hopefully no, it's trivial to drag them along forever, but I'll be
working to get them upstream as fast as I can, and it also provides a
very nice project for someone to pick up and work on, as a number of
developers already have.

thanks,

greg k-h
