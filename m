Return-Path: <linux-kernel-owner+w=401wt.eu-S1751476AbXBPMX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbXBPMX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 07:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbXBPMX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 07:23:58 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59074 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbXBPMX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 07:23:57 -0500
Date: Fri, 16 Feb 2007 13:24:03 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Simmons <jsimmons@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] MAINTAINERS: mark framebuffer as Orphan
Message-ID: <20070216122403.GM13958@stusta.de>
References: <20070215132549.c182f7bf.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702152224570.6415@pentafluge.infradead.org> <20070215150526.1fd63b3e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215150526.1fd63b3e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 03:05:26PM -0800, Randy Dunlap wrote:
> On Thu, 15 Feb 2007 22:26:10 +0000 (GMT) James Simmons wrote:
> 
> > 
> > I wouldn't say it orphan. I just can't spend 8 hours a day on it. 
> > Alot of patches have been flowing into the layer.
> 
> So would you like to leave it as Maintained or change it to
> "Odd Fixes"?  (Maintained => a maintainer)  From the MAINTAINTERS file:
> 
> 	Supported:	Someone is actually paid to look after this.
> 	Maintained:	Someone actually looks after it.
> 	Odd Fixes:	It has a maintainer but they don't have time to do
> 			much other than throw the odd patch in. See below..
> 	Orphan:		No current maintainer [but maybe you could take the
> 			role as you write your new code].
> 	Obsolete:	Old code. Something tagged obsolete generally means
> 			it has been replaced by a better system and you
> 			should be using that.
>...

If you start doing this, there are a lot more entries that need to be 
changed...

Which of Supported/Maintained/"Odd Fixes" is written doesn't matter in 
practice.

What matters is that James' email address gets into the entry so that 
patches and bug reports reach him.

James' work is definitely no below the average of entries marked as 
Maintained.

> ~Randy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

