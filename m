Return-Path: <linux-kernel-owner+w=401wt.eu-S1423178AbXBUViJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423178AbXBUViJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423174AbXBUViI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:38:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35825 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423141AbXBUViF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:38:05 -0500
Date: Wed, 21 Feb 2007 21:37:50 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] MAINTAINERS: mark framebuffer as Orphan
In-Reply-To: <20070216122403.GM13958@stusta.de>
Message-ID: <Pine.LNX.4.64.0702212136360.20620@pentafluge.infradead.org>
References: <20070215132549.c182f7bf.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0702152224570.6415@pentafluge.infradead.org>
 <20070215150526.1fd63b3e.randy.dunlap@oracle.com> <20070216122403.GM13958@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Alot of patches have been flowing into the layer.
> > 
> > So would you like to leave it as Maintained or change it to
> > "Odd Fixes"?  (Maintained => a maintainer)  From the MAINTAINTERS file:
> > 
> > 	Supported:	Someone is actually paid to look after this.
> > 	Maintained:	Someone actually looks after it.
> > 	Odd Fixes:	It has a maintainer but they don't have time to do
> > 			much other than throw the odd patch in. See below..
> > 	Orphan:		No current maintainer [but maybe you could take the
> > 			role as you write your new code].
> > 	Obsolete:	Old code. Something tagged obsolete generally means
> > 			it has been replaced by a better system and you
> > 			should be using that.
> >...
> 
> If you start doing this, there are a lot more entries that need to be 
> changed...
> 
> Which of Supported/Maintained/"Odd Fixes" is written doesn't matter in 
> practice.
> 
> What matters is that James' email address gets into the entry so that 
> patches and bug reports reach him.
> 
> James' work is definitely no below the average of entries marked as 
> Maintained.

At this point I would say maintained. Plus Tony is coming back :-)
Its just recently I have been working on various other things like the 
display class.
