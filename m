Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbXDZVej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbXDZVej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbXDZVej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:34:39 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:46065 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbXDZVei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:34:38 -0400
Date: Thu, 26 Apr 2007 22:34:36 +0100
To: Adrian Bunk <bunk@stusta.de>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070426213435.GA10048@skynet.ie>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <20070426165950.GO3468@stusta.de> <m3d51rhtid.fsf@maximus.localdomain> <20070426184516.GV3468@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070426184516.GV3468@stusta.de>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (26/04/07 20:45), Adrian Bunk didst pronounce:
> On Thu, Apr 26, 2007 at 08:37:14PM +0200, Krzysztof Halasa wrote:
> >...
> > With KNOWN_PROBLEMS information, sysadmins can decide if they can
> > safely upgrade to .0 or if they have to wait for .123.
> >...
> 
> Listing regressions like the following will most likely be zero help for 
> them when deciding whether to upgrade now or later (and BTW, the latter 
> might imply running a kernel with known security issues):
> 
> Subject    : acpi_pm clocksource loses time on x86-64
> References : http://lkml.org/lkml/2007/4/17/143
> Submitter  : Mikael Pettersson <mikpe@it.uu.se>
> Handled-By : John Stultz <johnstul@us.ibm.com>
>              Len Brown <lenb@kernel.org>
> Status     : problem is being debugged
> 

On the other hand when I was responsible for a bug, it was a great help
to see this sort of mail. Not only as it reminded I was responsible for a
screw-up but when I sent a fix out, these mails let me know it was being
picked up and ensured it made it to mainline.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
