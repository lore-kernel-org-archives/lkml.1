Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbXFPDft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbXFPDft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 23:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbXFPDfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 23:35:43 -0400
Received: from mraos.ra.phy.cam.ac.uk ([131.111.48.8]:46956 "EHLO
	mraos.ra.phy.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbXFPDfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 23:35:42 -0400
X-Greylist: delayed 2061 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 23:35:41 EDT
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Carlo Wood <carlo@alinoe.com>, Alexandre Oliva <aoliva@redhat.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, Sean <seanlkml@sympatico.ca>,
       Adrian Bunk <bunk@stusta.de>, Valdis.Kletnieks@vt.edu,
       Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <alpine.LFD.0.98.0706141153550.14121@woody.linux-foundation.org>
	<or1wgeco9v.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141311330.14121@woody.linux-foundation.org>
	<orir9q9rgl.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141424160.14121@woody.linux-foundation.org>
	<orps3y88ru.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141545470.14121@woody.linux-foundation.org>
	<orzm326s3w.fsf@oliva.athome.lsd.ic.unicamp.br>
	<87r6oeytin.fsf@jbms.ath.cx>
	<orsl8u54pa.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615124211.GA11830@alinoe.com>
	<20070615124211.GA11830@alinoe.com>
	<alpine.LFD.0.98.0706150748180.14121@woody.linux-foundation.org>
From: Sanjoy Mahajan <sanjoy@mrao.cam.ac.uk>
Date: 16 Jun 2007 04:00:32 +0100
In-Reply-To: <alpine.LFD.0.98.0706150748180.14121@woody.linux-foundation.org>
Message-ID: <r6lkek1u3z.fsf@inf-skye.phy.cam.ac.uk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> "version 2 or higher"

> That phrase exists outside the license

That's true.  But sec. 9 of the GPLv2 says:

  If the Program does not specify a version number of this License, you
  may choose any version ever published by the Free Software Foundation.

So, by making the COPYING contain the v2 text, is the author
specifying a particular version?  If yes, then the sec. 9 provision
would be meaningless, since there would be no way to not specify a
version number.  

My understanding is that courts would presume that a license term has
a meaning, if it has a plausible reading.  And there such a reading:
that to specify a version, there needs to be (e.g. in the source
files) a statement like, "This file [or work] is licensed under the
GNU GPLv2."

Corrections, flames, etc. are welcome.

-Sanjoy
