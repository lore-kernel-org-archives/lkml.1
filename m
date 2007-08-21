Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbXHUUIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbXHUUIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbXHUUIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:08:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34118 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbXHUUIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:08:46 -0400
Date: Tue, 21 Aug 2007 13:08:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Andi Kleen <ak@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: drop support for gcc < 4.0
In-Reply-To: <20070821195433.GE30705@stusta.de>
Message-ID: <alpine.LFD.0.999.0708211306560.30176@woody.linux-foundation.org>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com>
 <20070821173550.GC30705@stusta.de> <20070821191959.GC2642@bingen.suse.de>
 <20070821195433.GE30705@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Aug 2007, Adrian Bunk wrote:
> > 
> > Bogus warnings should be relatively harmless.
> 
> How many kernel developers use such old gcc versions?

It's NOT about "kernel developers".

It's about random people testing kernels.

If we make it harder for people to test kernels, we're going to lose. So 
no, I vote for *not* cutting off old gcc versions unless it's absolutely 
fatal.

		Linus
