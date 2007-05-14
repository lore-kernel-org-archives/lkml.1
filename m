Return-Path: <linux-kernel-owner+w=401wt.eu-S1761019AbXENUZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019AbXENUZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759345AbXENUZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:25:10 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34516 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759051AbXENUZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:25:08 -0400
Date: Mon, 14 May 2007 22:25:09 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, mgarski@post.pl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Convert files to UTF-8 and some cleanups
Message-ID: <20070514202509.GA1515@stusta.de>
References: <4647A52A.8000709@post.pl> <4647A868.4070201@post.pl> <46486EAE.3060009@s5r6.in-berlin.de> <Pine.LNX.4.61.0705141947390.9570@yvahk01.tjqt.qr> <tkrat.0d89f95b66d8bb2c@s5r6.in-berlin.de> <Pine.LNX.4.61.0705142209090.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0705142209090.9570@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 10:10:20PM +0200, Jan Engelhardt wrote:
> 
> On May 14 2007 20:06, Stefan Richter wrote:
> >On 14 May, Jan Engelhardt wrote:
> >> I've had a quick look at it...
> >> 
> >>   * Copyright (C) 2004 Nokia Corporation
> >>   * Written by Tony Lindgren <tony@atomide.com>
> >> - * Major cleanups by Juha YrjXlX <juha.yrjola@nokia.com>
> >> + * Major cleanups by Juha Yrjölä <juha.yrjola@nokia.com>
> >> 
> >> 
> >> I thought I already fixed that part with the patch from
> >> http://lkml.org/lkml/2007/1/8/222
> >> 
> >> but of course I can't tell without getting at that .bz2 thing I
> >> sent back them. Anyone know of a site that stores these too?
> >
> >http://marc.info/?l=linux-kernel&m=116828781409931
> 
> I checked.
> Now that kinda sucks, everyone does the same job over and over,
> I did a ton of utf8 fixes and they did not get applied. (Granted,
> I did not cc Andrew, Linus or trivial).

If you had Cc'ed trivial they would now be in Linus' tree...

> 	Jan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

