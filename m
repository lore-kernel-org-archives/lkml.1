Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbXA2WKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbXA2WKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932472AbXA2WKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:10:22 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47597 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752610AbXA2WKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:10:22 -0500
Date: Mon, 29 Jan 2007 23:10:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
Cc: andi@lisas.de, davej@codemonkey.org.uk,
       kernel list <linux-kernel@vger.kernel.org>, seife@suse.de,
       Wang Zhenyu <zhenyu.z.wang@intel.com>
Subject: Re: i965 testers wanted (Re: intel-agp PM experiences)
Message-ID: <20070129221006.GC17199@elf.ucw.cz>
References: <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com> <20070116142432.GA6171@elf.ucw.cz> <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com> <20070117004012.GA11140@rhlx01.hs-esslingen.de> <20070117005755.GB6270@elf.ucw.cz> <20070118115105.GA28233@rhlx01.hs-esslingen.de> <20070118231650.GA5352@ucw.cz> <20070122044519.GA24398@zhen-devel.sh.intel.com> <20070123094456.GG6033@ucw.cz> <1170108330.21603.5.camel@funkylaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170108330.21603.5.camel@funkylaptop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ok, I guess we'd like some testing here... so that in can be fixed in
> > mainline...
> 
> I can confirm that this patch is needed for my Intel Mac Mini to resume
> correctly when used without BIOS emulation (EFI mode). Here're the
> relevant lspci lines:

Can you attach the patch you tested (there was link above, but it did
not work for me), and try pushing it through maintainers?
								Pavel

> 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
> 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
> 
> Fred.
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
