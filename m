Return-Path: <linux-kernel-owner+w=401wt.eu-S1161151AbXCNLbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151AbXCNLbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161155AbXCNLbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:31:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59040 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161151AbXCNLba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:31:30 -0400
Date: Wed, 14 Mar 2007 12:31:33 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephane Casset <sept@logidee.com>, Jiri Slaby <jirislaby@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>, Tejun Heo <htejun@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org
Subject: Re: [6/6] 2.6.21-rc3: known regressions
Message-ID: <20070314113133.GA18731@stusta.de>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <20070313125025.GW18731@stusta.de> <1173816328.13341.101.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1173816328.13341.101.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 09:05:28PM +0100, Thomas Gleixner wrote:
> On Tue, 2007-03-13 at 13:50 +0100, Adrian Bunk wrote:
> > Subject    : hrtimer_switch_to_hres():
> >              wrong tick_init_highres() return value handling
> > References : http://lkml.org/lkml/2007/3/6/262
> > Submitter  : Linus Torvalds <torvalds@linux-foundation.org>
> > Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> >              commit 54cdfdb47f73b5af3d1ebb0f1e383efbe70fde9e
> > Handled-By : Thomas Gleixner <tglx@linutronix.de>
> > Status     : unknown
> 
> Linus merged the original patch, which solved the real problem. 
> 
> He just gave me a lesson how to do it right next time.

Sorry, my fault.

> 	tglx

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

