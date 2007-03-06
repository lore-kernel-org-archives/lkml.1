Return-Path: <linux-kernel-owner+w=401wt.eu-S965418AbXCFRzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965418AbXCFRzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965417AbXCFRzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:55:05 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:51523 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965416AbXCFRzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:55:03 -0500
Date: Tue, 6 Mar 2007 18:55:04 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 patch] the scheduled removal of OBSOLETE_OSS options
Message-ID: <20070306175504.GW3441@stusta.de>
References: <20070305014956.GE3441@stusta.de> <45EDA8EE.1060308@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45EDA8EE.1060308@tmr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 12:46:22PM -0500, Bill Davidsen wrote:
> Adrian Bunk wrote:
> >This patch contains the scheduled removal of the OBSOLETE_OSS options 
> >for 2.6.22.
> >
> If these are drivers for which there are thought to be useful ALSA 
> drivers, would it be reasonable to leave a stub for a help file naming 
> the driver which claims to support the hardware?
> 
> I'm not objection to the removal of the drivers, just noting that 
> identifying the new drivers can be made easier.

People compiling their own kernels aren't completely dumb - if you know 
about people having problems finding the right ALSA driver for their 
hardware, please name the concrete problems so that we can improve the 
description and/or help text of these ALSA options.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

