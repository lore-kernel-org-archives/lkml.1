Return-Path: <linux-kernel-owner+w=401wt.eu-S1751243AbXCJWIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbXCJWIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXCJWIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:08:30 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51118 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751205AbXCJWI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:08:28 -0500
Date: Sat, 10 Mar 2007 23:08:10 +0100
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stefan Seyfried <seife@suse.de>, Johannes Stezenbach <js@linuxtv.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
       Ash Milsted <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070310220810.GF2758@elf.ucw.cz>
References: <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu> <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org> <20070309174821.GA31754@linuxtv.org> <20070309233508.GB2197@elf.ucw.cz> <20070310090121.GB15647@elte.hu> <20070310114301.GA30554@suse.de> <20070310151804.GA10627@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310151804.GA10627@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ok. To be honest, you are the first reporter that seems to have read 
> > the documentation above, but not understood what to do.
> 
> thanks for the compliment ;-) _I_ very much know what to do (i mailed 
> the right person after all ;), but i dont really count and on the 6 

(Can we get the whitelist entries?)

> > i might consider reworking the documentation if there are more reports 
> > about problems with the procedure.
> 
> Probably tweaking the webpage doesnt help because people dont get there 
> - as the results plainly show it. Maybe some more automation would be 
> useful too, a tool that detects failed resume and tries all those 
> options that makes sense on that box or something? It's not like
> that 

Unfortunately, these tend to crash the box when you pass wrong
options, and I do not see easy way to test "can user see whats on
display" automatically.

Feel free to send patches, but I do not think it is easy/possible.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
