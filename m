Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbXKARvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbXKARvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXKARvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:51:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:48282 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752750AbXKARvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:51:46 -0400
Date: Thu, 1 Nov 2007 18:51:26 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Chris Holvenstot <cholvenstot@comcast.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Issue building kernel driver
Message-ID: <20071101175126.GA7227@stusta.de>
References: <1193938746.7555.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1193938746.7555.7.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 12:39:06PM -0500, Chris Holvenstot wrote:
> 
> Although it may not be popular with the crowd here, I do have a valid
> reason to run Windows - and I accomidate this using the VirtualBox
> product.  
> 
> Since I try to be slightly useful and build as many of the "test" kernel
> images I can I end up rebuilding the VirtualBox kernel driver (open
> source) on an almost daily basis.
>...
> I am not sure if this should be reported to the kernel folks or the
> VirtualBox folks - but the kernel code is what changed.  However I will
> post this on the VirtualBox forum too.

We had a (different) bug report involving exactly this external driver 
at some older post 2.6.23 kernel where it turned out it was a problem in 
this driver - and this one also looks really like a problem in their 
driver.

Generally, problems with external drivers should be reported to the 
vendors of these drivers and not here (unless it's clear it's a bug in 
the kernel and not in the driver).

> Thanks

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

