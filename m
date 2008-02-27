Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYB0SOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYB0SOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYB0SOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:14:25 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50233 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbYB0SOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:14:25 -0500
Date: Wed, 27 Feb 2008 20:13:03 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dominik Brodowski <linux@brodo.de>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the long overdue pcmcia_ioctl.c removal
Message-ID: <20080227181303.GB29269@cs181133002.pp.htv.fi>
References: <20080213213115.GW3383@cs181133002.pp.htv.fi> <20080218050133.23454db1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080218050133.23454db1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 05:01:33AM -0800, Andrew Morton wrote:
> On Wed, 13 Feb 2008 23:31:15 +0200 Adrian Bunk <bunk@kernel.org> wrote:
> 
> > pcmcia_ioctl.c was scheduled for removal in 2005, and it has a 
> > deprecation printk() since 2005 (sic).
> > 
> > This patch contains the long overdue removal and the cleanups that are 
> > now possible.
> 
> I've had this in -mm for ages, with a note that Dominik had a problem with
> it.  Maybe there are subtleties here, dunno.

This removal has bells and whistles and printk() since 2005...

Dominik, what exactly is the problem why we can't remove it now?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

