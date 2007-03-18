Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbXCRQNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbXCRQNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 12:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbXCRQNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 12:13:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46998 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbXCRQNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 12:13:10 -0400
Date: Sun, 18 Mar 2007 17:07:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, linux-pm@lists.osdl.org,
       lenb@kernel.org, linux-acpi@vger.kernel.org, luming.yu@intel.com,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>,
       Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net,
       Thomas Meyer <thomas.mey@web.de>, Meelis Roos <mroos@linux.ee>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Janosch Machowinski <jmachowinski@gmx.de>, vladimir.p.lebedev@intel.com,
       Ash Milsted <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070318160707.GC12673@elte.hu>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu> <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org> <20070309111957.GA3928@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309111957.GA3928@elf.ucw.cz>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> > Some day we may have modesetting support in the kernel for some 
> > graphics hw, right now it's pretty damn spotty.
> 
> Yep, that's the way to go.

hey, i wildly supported this approach ever since 1996, when GGI came up
:-/

	Ingo
