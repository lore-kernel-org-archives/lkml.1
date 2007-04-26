Return-Path: <linux-kernel-owner+w=401wt.eu-S1031435AbXDZSpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031435AbXDZSpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031420AbXDZSpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:45:07 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35560 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031435AbXDZSpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:45:06 -0400
Date: Thu, 26 Apr 2007 20:45:16 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070426184516.GV3468@stusta.de>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <20070426165950.GO3468@stusta.de> <m3d51rhtid.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m3d51rhtid.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 08:37:14PM +0200, Krzysztof Halasa wrote:
>...
> With KNOWN_PROBLEMS information, sysadmins can decide if they can
> safely upgrade to .0 or if they have to wait for .123.
>...

Listing regressions like the following will most likely be zero help for 
them when deciding whether to upgrade now or later (and BTW, the latter 
might imply running a kernel with known security issues):

Subject    : acpi_pm clocksource loses time on x86-64
References : http://lkml.org/lkml/2007/4/17/143
Submitter  : Mikael Pettersson <mikpe@it.uu.se>
Handled-By : John Stultz <johnstul@us.ibm.com>
             Len Brown <lenb@kernel.org>
Status     : problem is being debugged

> Krzysztof Halasa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

