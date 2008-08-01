Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbYHAVW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbYHAVW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761286AbYHAVPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:15:25 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40691 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761339AbYHAVPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:15:23 -0400
Date: Sat, 2 Aug 2008 00:14:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Or Gerlitz <ogerlitz@voltaire.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: error building linus tree (2.6.27-rc1)
Message-ID: <20080801211420.GE19682@cs181140183.pp.htv.fi>
References: <Pine.LNX.4.64.0807292357040.3348@zuben.voltaire.com> <Pine.LNX.4.64.0808012312260.10651@zuben.voltaire.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808012312260.10651@zuben.voltaire.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 11:14:10PM +0300, Or Gerlitz wrote:
> On Wed, 30 Jul 2008, Or Gerlitz wrote:
> 
> > I get into this
> > arch/x86/kernel/ldt.c: In function `alloc_ldt':
> > arch/x86/kernel/ldt.c:67: error: invalid lvalue in unary `&'
> 
> Here's the gcc and as versions
> 
> $ gcc --version
> gcc (GCC) 3.4.6 20060404 (Red Hat 3.4.6-8)
> Copyright (C) 2006 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>...

Ah, thanks.

It's a known problem that has just been fixed in Linus' tree.

> Or.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

