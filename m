Return-Path: <linux-kernel-owner+w=401wt.eu-S934173AbXEER4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934173AbXEER4I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934170AbXEER4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:56:08 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35298 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934164AbXEER4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:56:07 -0400
Date: Sat, 5 May 2007 19:56:05 +0200
From: Andreas Mohr <andi@rhlx01.hs-esslingen.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andreas Mohr <andi@rhlx01.fht-esslingen.de>, Andrew Morton <akpm@osdl.org>,
       davej@codemonkey.org.uk, dri-devel <dri-devel@lists.sourceforge.net>,
       linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] working 3D/DRI intel-agp.ko resume for i815 chip; Intel chipset testers wanted! (was: Re: intel-agp PM experiences ...)
Message-ID: <20070505175605.GA24615@rhlx01.hs-esslingen.de>
References: <20070116135727.GA2831@elf.ucw.cz> <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com> <20070116142432.GA6171@elf.ucw.cz> <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com> <20070117004012.GA11140@rhlx01.hs-esslingen.de> <20070117005755.GB6270@elf.ucw.cz> <20070118115105.GA28233@rhlx01.hs-esslingen.de> <20070118231650.GA5352@ucw.cz> <20070501145947.GA19953@rhlx01.hs-esslingen.de> <20070502101718.GC10245@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502101718.GC10245@elf.ucw.cz>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[dri-devel added]

Hi,

On Wed, May 02, 2007 at 12:17:18PM +0200, Pavel Machek wrote:
> > Took way longer than I'd have wanted it to (nice daughter and stuff ;),
> > but here it is.
> 
> No problem.
> 
> Ok, I guess we'll  need a real commit log.

Thanks to all the people who replied and sent some suggestions!

Due to the "scathing" (well, thorough ;) code review I'll send a patch
with those cleanups against 2.6.21-mm1 very soon.
(I was actually a bit surprised to see akpm commit this thing after this
review mail, but it's ok since it lets people experiment with it).

Thanks!

Andreas Mohr
