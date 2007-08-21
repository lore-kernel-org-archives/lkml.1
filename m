Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbXHUUWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbXHUUWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXHUUWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:22:09 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56117 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751026AbXHUUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:22:06 -0400
Date: Tue, 21 Aug 2007 22:21:13 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: drop support for gcc < 4.0
Message-ID: <20070821202113.GF30705@stusta.de>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de> <20070821191959.GC2642@bingen.suse.de> <20070821195433.GE30705@stusta.de> <alpine.LFD.0.999.0708211306560.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708211306560.30176@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 01:08:25PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 21 Aug 2007, Adrian Bunk wrote:
> > > 
> > > Bogus warnings should be relatively harmless.
> > 
> > How many kernel developers use such old gcc versions?
> 
> It's NOT about "kernel developers".
> 
> It's about random people testing kernels.
> 
> If we make it harder for people to test kernels, we're going to lose. So 
> no, I vote for *not* cutting off old gcc versions unless it's absolutely 
> fatal.

How many people e.g. test -rc kernels compiled with gcc 3.2?

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

