Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbXCMSNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbXCMSNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbXCMSNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:13:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44088 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752611AbXCMSNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:13:33 -0400
Date: Tue, 13 Mar 2007 19:13:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>, maxk@qualcomm.com,
       bluez-devel@lists.sourceforge.net
Subject: Re: [2/6] 2.6.21-rc3: known regressions
Message-ID: <20070313181325.GB12224@elf.ucw.cz>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <20070313125003.GS18731@stusta.de> <20070313143034.77425af4@gondolin.boeblingen.de.ibm.com> <45F6A89C.50406@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6A89C.50406@rtr.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Adrian Bunk <bunk@stusta.de> wrote:
> >
> >>Subject    : ThinkPad X60: bluetooth hardlocks
> >>References : http://lkml.org/lkml/2007/3/2/85
> >>Submitter  : Pavel Machek <pavel@ucw.cz>
> >>Handled-By : Marcel Holtmann <marcel@holtmann.org>
> >>Status     : unknown
> >
> >Does this still happen with -rc3? I'd have thought Mark's patch in
> >0de1517e23c2e28d58a6344b97a120596ea200bb fixed that...
> 
> Pavel?  Could you retest this now on a ThinkPad X60 ?

I can confirm it is fixed.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
