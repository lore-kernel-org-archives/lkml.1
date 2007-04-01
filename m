Return-Path: <linux-kernel-owner+w=401wt.eu-S965136AbXDAVDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965136AbXDAVDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 17:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965176AbXDAVDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 17:03:05 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33048 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965136AbXDAVDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 17:03:02 -0400
Date: Sun, 1 Apr 2007 23:03:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [pp] kbuild: asm-offsets generalized
Message-ID: <20070401210346.GB10761@uranus.ravnborg.org>
References: <1171024771.2718.129.camel@localhost.localdomain> <20070209141728.GA26749@uranus.ravnborg.org> <1171034599.2718.190.camel@localhost.localdomain> <E1HGbJz-0003Lc-6h@flower> <1171323696.19842.29.camel@localhost.localdomain> <20070213031044.GA17046@flower.upol.cz> <20070216155527.GA14687@flower.upol.cz> <20070216155929.GA14713@flower.upol.cz> <20070401204203.GA10761@uranus.ravnborg.org> <20070401210803.GF10959@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070401210803.GF10959@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2007 at 11:08:03PM +0200, Oleg Verych wrote:
> On Sun, Apr 01, 2007 at 10:42:03PM +0200, Sam Ravnborg wrote:
> > On Fri, Feb 16, 2007 at 04:59:29PM +0100, Oleg Verych wrote:
> []
> > > [patch proposition] kbuild: asm-offsets generalized
> []
> > >  * (hopefully) more readable sed scripts,
> > > 
> > >  * top Kbuild may be updated...
> []
> > 
> > Can I ask you to provide a complete patch that replaces the current
> > asm-offset stuff with your more readable script version.
>  
> OK, unless this is 1st April joke ;)
> 
> > >  * scripts/mkCconstants:
> > >    - asm-offsets magic demystified, generalized,
> 
> > Name the script: mkasm-offset.sh to make a direct connection to 
> > the resulting .h file name.
>  
> OK, nice name.
> 
> > > 
> > >  * file needs `chmod u+x`, i don't know, how it's done in patch(1).
> 
> BTW, i'll look at git-diff/git-apply for doing that, as was noted by Linus.
When patch passes me I can take care - so do not worry.
But tell me to do so if I should forget in the meantime.

PS. On vacation for a week from tomorrow so take your time.

	Sam
