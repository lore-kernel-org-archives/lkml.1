Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbXCMSOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbXCMSOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932069AbXCMSOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:14:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44102 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753306AbXCMSOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:14:14 -0400
Date: Tue, 13 Mar 2007 19:14:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
       Tomas Janousek <tomi@nomi.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Soeren Sonnenburg <kernel@nn7.de>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>,
       Lukas Hejtmanek <xhejtman@mail.muni.cz>
Subject: Re: [5/6] 2.6.21-rc3: known regressions
Message-ID: <20070313181404.GC12224@elf.ucw.cz>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <20070313125016.GV18731@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313125016.GV18731@stusta.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This email lists some known regressions in Linus' tree compared to 2.6.20.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way
> possibly involved with one or more of these issues.
> 
> Due to the huge amount of recipients, please trim the Cc when answering.
> 
> 
> Subject    : resume: slab error in verify_redzone_free(): cache `size-512':
>                      memory outside object was overwritten
> References : http://lkml.org/lkml/2007/2/24/41
> Submitter  : Pavel Machek <pavel@ucw.cz>
> Status     : unknown
> 
> 
> Subject    : beeps get longer after suspend
> References : http://lkml.org/lkml/2007/2/26/276
> Submitter  : Pavel Machek <pavel@ucw.cz>
> Status     : unknown

Seems fixed in -rc3.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
