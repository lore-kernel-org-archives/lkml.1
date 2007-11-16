Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbXKPT6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbXKPT6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXKPT6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:58:18 -0500
Received: from waste.org ([66.93.16.53]:48411 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbXKPT6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:58:17 -0500
Date: Fri, 16 Nov 2007 13:57:45 -0600
From: Matt Mackall <mpm@selenic.com>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: Mark Lord <lkml@rtr.ca>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.2
Message-ID: <20071116195745.GC17536@waste.org>
References: <20071116183752.GA9807@kroah.com> <20071116183940.GC9807@kroah.com> <473DF101.3010501@rtr.ca> <20071116193958.GJ6372@mea-ext.zmailer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116193958.GJ6372@mea-ext.zmailer.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 09:39:58PM +0200, Matti Aarnio wrote:
> On Fri, Nov 16, 2007 at 02:35:29PM -0500, Mark Lord wrote:
> > Greg Kroah-Hartman wrote:
> >> We (the -stable team) are announcing the release of the 2.6.23.2 kernel.
> >> It contains a number of bugfixes for the core kernel code.
> >> I'll also be replying to this message with a copy of the patch between
> >> 2.6.23.1 and 2.6.23.2
> > ..
> >> Tsugikazu Shibata (1):
> >>       HOWTO: update ja_JP/HOWTO with latest changes
> > ..
> >
> > So what is the magic command to apply this patch successfully?
> > It keeps rejecting the Documentation/ja_JP/HOWTO updates here.
> 
> Hammer GIT coders into sensibility to add proper MIME headers
> on these patch post.  Then, perhaps, things will just work.

What is the proper encoding for a patch that contains hunks in
multiple character sets?

-- 
Mathematics is the supreme nostalgia of our time.
