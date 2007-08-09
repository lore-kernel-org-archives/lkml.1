Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbXHIXFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbXHIXFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 19:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbXHIXEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 19:04:52 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54613 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751430AbXHIXEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 19:04:52 -0400
Date: Fri, 10 Aug 2007 01:04:36 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, akpm@linux-foundation.org
Subject: Re: [2.6 patch] cpqphp_ctrl.c: remove dead code
Message-ID: <20070809230436.GA18938@stusta.de>
References: <20070723145105.GK26212@stusta.de> <20070809145140.654303a0.kristen.c.accardi@intel.com> <20070809222427.GA32127@suse.de> <20070809154702.caa67a61.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070809154702.caa67a61.kristen.c.accardi@intel.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 03:47:02PM -0700, Kristen Carlson Accardi wrote:
> 
> fine by me - let's NAK this patch (and all future ones for this driver) until 
> someone with hardware steps up to maintain this driver.  Eventually it
> will just die I guess.

We have tons of unmaintained drivers and none of them has such a silly 
auto-NAK policy.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

