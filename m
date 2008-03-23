Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbYCWEIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbYCWEIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 00:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbYCWEIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 00:08:06 -0400
Received: from ns2.suse.de ([195.135.220.15]:39504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbYCWEIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 00:08:05 -0400
Date: Sat, 22 Mar 2008 21:13:11 -0700
From: Greg KH <gregkh@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Miller <davem@davemloft.net>, jesper.juhl@gmail.com,
       chrisw@sous-sol.org, linux-kernel@vger.kernel.org, stable@kernel.org,
       jmforbes@linuxtx.org, zwane@arm.linux.org.uk, tytso@mit.edu,
       rdunlap@xenotime.net, davej@redhat.com, chuckw@quantumlinux.com,
       reviews@ml.cw.f00f.org, mkrufky@linuxtv.org, cebbert@redhat.com,
       cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 07/76] NIU: Bump driver version and release date.
Message-ID: <20080323041311.GA4663@suse.de>
References: <20080321224250.144333319@sous-sol.org> <20080321224333.400857992@sous-sol.org> <9a8748490803211710u4c5d1d67x2a5a891347e0adf6@mail.gmail.com> <20080321.171401.49157146.davem@davemloft.net> <84144f020803221557t36502f6bo327c95705be706bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020803221557t36502f6bo327c95705be706bf@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2008 at 12:57:29AM +0200, Pekka Enberg wrote:
> Furthermore, I honestly don't see how your patch meets the (rather
> strict) requirements of stable series either. So it would be nice if
> one of the stable maintainers stepped up to say that these kind of
> patches are okay to set a precedent for others as well.

These kind of patches are perfectly fine.  We trust the maintainers of
drivers and subsystems to tell the -stable maintainers what they want
added to the tree, and if that includes a version number update to make
their lives easier, who are we to say no to that.

Becides, it's not the first time patches like this have been accepted.

thanks,

greg k-h
