Return-Path: <linux-kernel-owner+w=401wt.eu-S1752285AbXA0RjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbXA0RjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 12:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbXA0Ri7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 12:38:59 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39685 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752275AbXA0Ri7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 12:38:59 -0500
Date: Sat, 27 Jan 2007 18:39:07 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Malte =?utf-8?B?U2NocsO2ZGVy?= <MalteSch@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-dev@namesys.com
Subject: Re: 2.6.20-rc6: known unfixed regressions (part 2)
Message-ID: <20070127173907.GM6017@stusta.de>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> <20070126181132.GN17836@stusta.de> <200701261916.29805.MalteSch@gmx.de> <20070127172801.GK6017@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070127172801.GK6017@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 06:28:01PM +0100, Adrian Bunk wrote:
> On Fri, Jan 26, 2007 at 07:16:25PM +0100, Malte Schröder wrote:
> > On Friday 26 January 2007 19:11, Adrian Bunk wrote:
> > > Subject    : BUG: at mm/truncate.c:60 cancel_dirty_page()  (reiserfs)
> > > References : http://lkml.org/lkml/2007/1/7/117
> > >              http://lkml.org/lkml/2007/1/10/202
> > > Submitter  : Malte Schröder <MalteSch@gmx.de>
> > > Handled-By : Vladimir V. Saveliev <vs@namesys.com>
> > >              Nick Piggin <nickpiggin@yahoo.com.au>
> > > Patch      : http://lkml.org/lkml/2007/1/10/202
> > > Status     : problem is being discussed
> > 
> > This did not happen again.
> 
> Unless I misunderstand this issue, we want this fixed before 2.6.20 
> because otherwise many people might see this BUG message.

/me looks:
The warning was already removed post -rc6.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

