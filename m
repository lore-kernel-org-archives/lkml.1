Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZH0Dfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZH0Dfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZH0DfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:35:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:58583 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbZH0DfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:35:00 -0400
Date: Wed, 26 Aug 2009 20:33:15 -0700
From: Greg KH <gregkh@suse.de>
To: "J.H." <warthog9@kernel.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Dave Young <hidave.darkstar@gmail.com>, webmaster@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: mm/-next release on kernel.org web page?
Message-ID: <20090827033315.GA32648@suse.de>
References: <a8e1da0908020056mbf28eaw611c605693eb3eff@mail.gmail.com>
 <20090802095523.e08166e3.rdunlap@xenotime.net>
 <a8e1da0908021908x8216693k7fb31bc5b58d6666@mail.gmail.com>
 <20090802193045.c3f3195c.rdunlap@xenotime.net>
 <4A766F39.7090903@kernel.org>
 <4A95D677.2020807@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A95D677.2020807@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 05:42:31PM -0700, J.H. wrote:
> 
> Not to reply to myself, but I've pushed out an update that should 
> incorporate the expected trees now, this does eliminate the 2.2 and all 
> but the last 2.4 tree (2.4.37.5), but does include all of the stable 
> 2.6.x trees, the snapshots and linux-next.  Frontpage, finger and rss 
> should all be showing the new information universally.  I'll probably 
> tweak things a bit more (layout and such for the rss & html) but the 
> kernels should now be listed as people expect.

This looks a lot better, thanks.  But note that the 2.6.28 and 2.6.29
stable series are no longer maintained, and the current versions of them
have known security issues, so it might not be a good idea to show that
they are recommended for use at all.

Is there some way that we can "mark" activly maintained releases to have
them show up on the front page in any way?  We can use the LATEST-IS
type file in the kernel directory if you want, that would be a simple
way to maintain this information.

thanks,

greg k-h
