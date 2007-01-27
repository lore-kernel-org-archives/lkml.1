Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbXA0R1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbXA0R1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 12:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbXA0R1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 12:27:54 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39620 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752278AbXA0R1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 12:27:53 -0500
Date: Sat, 27 Jan 2007 18:28:01 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Malte =?utf-8?B?U2NocsO2ZGVy?= <MalteSch@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-dev@namesys.com
Subject: Re: 2.6.20-rc6: known unfixed regressions (part 2)
Message-ID: <20070127172801.GK6017@stusta.de>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> <20070126181132.GN17836@stusta.de> <200701261916.29805.MalteSch@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200701261916.29805.MalteSch@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 07:16:25PM +0100, Malte Schröder wrote:
> On Friday 26 January 2007 19:11, Adrian Bunk wrote:
> > Subject    : BUG: at mm/truncate.c:60 cancel_dirty_page()  (reiserfs)
> > References : http://lkml.org/lkml/2007/1/7/117
> >              http://lkml.org/lkml/2007/1/10/202
> > Submitter  : Malte Schröder <MalteSch@gmx.de>
> > Handled-By : Vladimir V. Saveliev <vs@namesys.com>
> >              Nick Piggin <nickpiggin@yahoo.com.au>
> > Patch      : http://lkml.org/lkml/2007/1/10/202
> > Status     : problem is being discussed
> 
> This did not happen again.

Unless I misunderstand this issue, we want this fixed before 2.6.20 
because otherwise many people might see this BUG message.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

