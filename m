Return-Path: <linux-kernel-owner+w=401wt.eu-S1031458AbXDZTTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031458AbXDZTTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031459AbXDZTTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:19:01 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35612 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031458AbXDZTTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:19:00 -0400
Date: Thu, 26 Apr 2007 21:19:10 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070426191910.GX3468@stusta.de>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <4630E00B.3090502@tmr.com> <4630E9C8.5060000@garzik.org> <20070426183602.GT3468@stusta.de> <20070426185851.GA7352@electric-eye.fr.zoreil.com> <4630F9CB.10600@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4630F9CB.10600@garzik.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 03:13:15PM -0400, Jeff Garzik wrote:
> Francois Romieu wrote:
>> Pointer for the rtl8139 regression please ?
>
> I'm guessing it's this one:
>
>> 	Subject    : boot failure: rtl8139: exception in interrupt routine
>> 	References : http://lkml.org/lkml/2007/3/31/160
>> 	Submitter  : Stephen Clark <Stephen.Clark@seclark.us>
>> 	Status     : unknown
>
>
> The poster says rtl8139, but doesn't provide more info.  His lspci says 
> "RTL8169SC", which sounds more like r8169 to me.

Interesting.

I didn't notice it, Andrew didn't notice it, and it seems that although 
it was in three posted versions of my regression lists, noone looked at 
this bug (or it would have been noticed earlier).

> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

