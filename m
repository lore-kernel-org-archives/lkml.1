Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbXE1Mx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbXE1Mx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 08:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbXE1MxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 08:53:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52000 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751123AbXE1MxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 08:53:22 -0400
Date: Mon, 28 May 2007 14:53:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1 Implementing fan/thermal control in userspace - Was: [cannot change thermal trip points]
Message-ID: <20070528125321.GH18807@elf.ucw.cz>
References: <20070521134046.GE8332@elf.ucw.cz> <20070521134553.GA7911@srcf.ucam.org> <20070521224200.GF10714@elf.ucw.cz> <20070522003153.GA18162@srcf.ucam.org> <1180016213.16396.74.camel@queen.suse.de> <20070524143644.GA27364@srcf.ucam.org> <20070525063815.GA3989@ucw.cz> <20070527215123.GA22687@srcf.ucam.org> <20070528105851.GE18807@elf.ucw.cz> <20070528125035.GA29738@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528125035.GA29738@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-05-28 13:50:36, Matthew Garrett wrote:
> On Mon, May 28, 2007 at 12:58:51PM +0200, Pavel Machek wrote:
> 
> > It would happily occur under Windows. You just needed to load machine
> > in a way that cpu stayed ~80C.
> 
> So replace the DSDT. All the problems get solved that way.

We are in the middle of stable series, and Len's patch breaks existing
setups without prior warning. That's "no-no". Of course I could
replace DSDT. I also could throw that machine out of window.

I'm not sure what we are arguing about here, that patch is broken.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
