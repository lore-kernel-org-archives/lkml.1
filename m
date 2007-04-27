Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbXD0QcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbXD0QcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbXD0QcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:32:08 -0400
Received: from thunk.org ([69.25.196.29]:53987 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049AbXD0QcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:32:07 -0400
Date: Fri, 27 Apr 2007 12:31:43 -0400
From: Theodore Tso <tytso@mit.edu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070427163143.GG24852@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <20070426165950.GO3468@stusta.de> <20070426215015.003f6196@the-village.bc.nu> <20070427145805.GT3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427145805.GT3468@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 04:58:05PM +0200, Adrian Bunk wrote:
> "no regressions" is definitely not feasible.
> 
> 14 known regressions, some of them not yet debugged at all, are 
> different from your "some small regression".

Yes, but when were some of these regressions reported?  Past a certain
point, I think it's reasonable to look at the regression, decide how
many people would be affected by it, and why it hadn't been noticed
earlier, and in some cases, decide that it's better to get this
debugged and fixed in the stable and development trees in parallel.

> And look e.g. at the many (and non-trivial) changes between -rc7 and 
> -final, resulting in more than one report from people who were running 
> -rc7 without problems - and 2.6.21 doesn't work for them.

I agree that's unfortunate.

> It's not a choice between "regressions don't matter" and "no regressions",
> it's about the place in the area between these two extremes. I have my 
> opinions on what I want to expect from a stable Linux kernel, and other 
> people have different opinins.

Everyone is going to disagree to some extent; and their own comfort
zone.  So a certain amount compromise is always going to be necessary.
Of course, it's up to you decide whether this has gone beyond the zone
where you aren't comfortable working with other people's development
style.

Regards,

					- Ted
