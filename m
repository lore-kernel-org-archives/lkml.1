Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbZBEXpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbZBEXpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZBEXpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:45:36 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:53116 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752353AbZBEXpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:45:35 -0500
Message-ID: <498B7A1D.8060303@snapgear.com>
Date: Fri, 06 Feb 2009 09:45:33 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: uClinux development list <uclinux-dev@uclinux.org>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-m68k@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [uClinux-dev] Re: Fix support for console port other than ttyS0
 on	mcf.c
References: <20090204201518.GH26064@csclub.uwaterloo.ca>	<20090204202009.GI26064@csclub.uwaterloo.ca>	<Pine.LNX.4.64.0902042200340.25136@anakin>	<20090205152751.GL26064@csclub.uwaterloo.ca>	<Pine.LNX.4.64.0902051652080.5127@anakin>	<20090205155700.GO26064@csclub.uwaterloo.ca> <Pine.LNX.4.64.0902051734500.5127@anakin>
In-Reply-To: <Pine.LNX.4.64.0902051734500.5127@anakin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Geert Uytterhoeven wrote:
> On Thu, 5 Feb 2009, Lennart Sorensen wrote:
>> On Thu, Feb 05, 2009 at 04:53:50PM +0100, Geert Uytterhoeven wrote:
>>> linux-m68k@lists.linux-m68k.org handles m68k (with MMU) only.
>>> uclinux-dev@uclinux.org handles m68knommu.
>> Oh.  I think I got confused by the fact the same arch/m68k/include is
>> used for both. so I looked up m68k in MAINTAINERS.

Well, you could try sending to the listed author at the top of mcf.c
as well :-)

Regards
Greg



> Yeah, we just merged it a few day ago :-)
> 
> The goal is to merge arch/m68k{,nommu}, too (eventually)...
> 
>> I will start bothering uclinux-dev@uclinux.org instead.
>>
>> So by uclinux driver you meant m68knommu uclinux driver.  I was thinking
>> uclibc for some reason.
> 
> Yes, m68knommu uclinux driver.
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> _______________________________________________
> uClinux-dev mailing list
> uClinux-dev@uclinux.org
> http://mailman.uclinux.org/mailman/listinfo/uclinux-dev
> This message was resent by uclinux-dev@uclinux.org
> To unsubscribe see:
> http://mailman.uclinux.org/mailman/options/uclinux-dev
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
