Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbYFUVxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbYFUVxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 17:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYFUVxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 17:53:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42393 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYFUVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 17:53:11 -0400
Date: Sat, 21 Jun 2008 14:50:59 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: How linux-staging is released (was Re:
	linux-staging/linux-next merge/build errors)
Message-ID: <20080621215059.GD15341@kroah.com>
References: <20080621124017.ec3b0a51.sfr@canb.auug.org.au> <20080621071956.GB2765@kroah.com> <1214053209.3223.220.camel@lappy.programming.kicks-ass.net> <20080621175003.GC14786@kroah.com> <1214071343.3223.249.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214071343.3223.249.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 08:02:22PM +0200, Peter Zijlstra wrote:
> The point was that for some people being carried by distos is upstream
> enough.
> 
> So I would discourage distros form picking up this tree.

I wouldn't, as some of the drivers work just fine on some arches, but
not all, that is why they are not in mainline yet (the network drivers
in there right now are an example of this.)

> The scenario I was thinking about is some HW vendor writing a shitty
> driver, dumping it in your tree - getting picked up by $DISTRO and
> saying, job done, people can use it. Leaving you to pick up the pieces -
> which, with you not having hw-docs, is a hard job.

If this happens, I'll deal with it then :)

thanks,

greg k-h
