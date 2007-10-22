Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbXJVTlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbXJVTlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbXJVTlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:41:32 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58995 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753008AbXJVTlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:41:31 -0400
Date: Mon, 22 Oct 2007 21:42:00 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: char/cyclades.c: inconsequent NULL checking
Message-ID: <20071022194200.GO30533@stusta.de>
References: <20071022024734.GI30533@stusta.de> <471CF4AC.6060603@gmail.com> <Pine.LNX.4.64.0710222112070.18815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710222112070.18815@twin.jikos.cz>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 09:12:23PM +0200, Jiri Kosina wrote:
> On Mon, 22 Oct 2007, Jiri Slaby wrote:
> 
> > > The Coverity checker spotted the following inconsequent NULL checking in 
> > Where can one obtain such a checker?
> 
> That's a commercial proprietary thingie.
> 
> http://www.coverity.com/

A bit more of background:

The US Department of Homeland Security pays them some money for scanning 
open source projects, the Linux kernel is one of these projects, and 
kernel developers can therefore get access to the database with the
results from their regular scans of Linus' tree.

I'm not a fan of proprietary software, but I'm simply considering their 
results as bug reports that are worth looking at.

> Jiri Kosina

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

