Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbZCaGxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbZCaGxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbZCaGxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:53:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35634 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbZCaGxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:53:08 -0400
Date: Tue, 31 Mar 2009 08:52:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, eric.piel@tremplin-utc.net,
       Luca Cappa <lcappa@gmail.com>
Subject: Re: axes conversion for hp compaq 8710w for HP_ACCEL linux kernel
	module (fwd)
Message-ID: <20090331065254.GE17800@elf.ucw.cz>
References: <20090321230819.GF12291@elf.ucw.cz> <20090330155533.ee3e6dae.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330155533.ee3e6dae.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Greetings,
> > Luca
> > 
> > 
> > --- /home/luca/Desktop/hp_accel.c	2009-03-21 19:28:54.000000000 +0100
> > +++ hp_accel.c	2009-03-21 19:31:05.000000000 +010
> > @@ -201,6 +201,7 @@
> >  			PRODUCT_NAME, "HP Pavilion dv5",
> >  			BOARD_NAME, "3600",
> >  			y_inverted),
> > +    AXIS_DMI_MATCH("HP8710", "HP Compaq 8710", y_inverted),
> >  	{ NULL, }
> >  /* Laptop models witho
> 
> - changelog is a mess
> - originator wasn't cc'ed
> - originator's signed-off-by: is missing
> - your signed-off-by: is missing
> - patch isn't in `patch -p1' form
> - patch is whitespace-mangled
> 
> I fixed some of that up.  It'd be nice to get some Signed-off-by:s,
> please.

Sorry about the mess you had to clean up.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
