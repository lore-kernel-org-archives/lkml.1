Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYGBXQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYGBXQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 19:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYGBXQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 19:16:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49942 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYGBXQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 19:16:10 -0400
Date: Wed, 2 Jul 2008 16:11:18 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors@vger.kernel.org, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] linux-staging tree created
Message-ID: <20080702231118.GB20129@kroah.com>
References: <20080610190540.GA25066@kroah.com> <20080617125103.GA4211@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080617125103.GA4211@ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 02:51:04PM +0200, Pavel Machek wrote:
> Hi!
> 
> > What this tree is not:
> > 	- it is not a place to dump code and then run away, hoping that
> > 	  someone else will do the cleanup work for you.  While there
> > 	  are developers available to do this kind of work, you need to
> > 	  get someone to agree to "babysit" the code.
> 
> Hmm, how do I tap into that developer pool? :-)
> 
> Kohjinsha wifi driver is in state where it was ported to mac80211, and
> it still works with minimum features, but it needs dead code removal
> and rewriting the rest. That code is really very ugly.
> 
> I can do the handholding; I can probably do the rewrite, too (its
> 10000LoC), but it will take time...

If the patch at least builds, send it to me for inclusion in -staging if
you want to get some exposure for it.

thanks,

greg k-h
