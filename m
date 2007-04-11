Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbXDKSBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbXDKSBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbXDKSBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:01:36 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47777 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753469AbXDKSBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:01:36 -0400
Date: Wed, 11 Apr 2007 20:01:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Rene Rebe <rene@exactcode.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.16.47-rc1
Message-ID: <20070411180140.GE10141@stusta.de>
References: <20070411141408.GC10141@stusta.de> <200704111834.32705.rene@exactcode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704111834.32705.rene@exactcode.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 06:34:32PM +0200, Rene Rebe wrote:

> Hi Adrian,

Hi René,

> first front off: thanks for the phantastic 2.6.16 stable maintenance.
> 
> Currently I wonder if you have any plan for doing the 2.6.16 review
> for let's say "years", or if you "soon" pick some new series such as
> 2.6.20 or so for long-term maintenance.

I'm not yet decided whether I'll do the same for some future kernel, but 
even if I'll do it, that wouldn't imply an immediate dropping of the 
2.6.16 series - especially since in a "security fixes only" mode 
maintaining it would require nearly zero work.

> I ask because I wonder if I should wait a bit with a production 2.6.17
> kernel line I maintain right now for just one installation base, if you
> choose some 2.6.2x I can hop on, or whether it is wiser to just downdate
> this series and profit from the "long-term" 2.6.16 maintenance that is
> no fun to replicate for 2.6.17 just for this one install pool ...

If I'll maintain a more recent kernel series, that would be >= 2.6.22.
So if you need something in the near future that wouldn't help you.

If 2.6.16 works for you that sounds like a good option, otherwise you 
could get security support [1] by building upon some distribution kernel 
(e.g. Ubuntu 6.10 that will get security updates for the next 12 months 
ships with a 2.6.17 kernel).

> Thanks in advance,

cu
Adrian

[1] and that's what the "long-term maintenance" of 2.6.16 is really
    about: no regressions and security fixes

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

