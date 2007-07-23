Return-Path: <linux-kernel-owner+w=401wt.eu-S933809AbXGWBob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809AbXGWBob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbXGWBoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:44:23 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41565 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755191AbXGWBoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:44:23 -0400
Date: Mon, 23 Jul 2007 03:43:48 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Roland McGrath <roland@redhat.com>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: Linus 2.6.23-rc1
Message-ID: <20070723014348.GX26212@stusta.de>
References: <20070723000732.GP26212@stusta.de> <20070723003103.0E8D04D0489@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070723003103.0E8D04D0489@magilla.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 05:31:03PM -0700, Roland McGrath wrote:
> > That's the Debian unstable package of binutils containing what was on 
> > 20070718 in the upstream binutils CVS (the version number comes from 
> > the upstream CVS).
> 
> At what time on July 18?  Before or after the commits I made that day?

ld/ChangeLog contains your entry for this day.

> You see, I can't tell from the information at hand.

The information comes directly from bfd/version.h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

