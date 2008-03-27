Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYC0SHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYC0SHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 14:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYC0SHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 14:07:25 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50863 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbYC0SHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 14:07:25 -0400
Date: Thu, 27 Mar 2008 20:07:13 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Douglas Thompson <dougthompson@xmission.com>,
       Tim Small <tim@buttersideup.com>, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: EDAC_I82443BXGX still depends on BROKEN
Message-ID: <20080327180713.GC32200@cs181133002.pp.htv.fi>
References: <20080327173610.GB32200@cs181133002.pp.htv.fi> <20080327175224.GA15887@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080327175224.GA15887@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 10:52:24AM -0700, Greg KH wrote:
> On Thu, Mar 27, 2008 at 07:36:11PM +0200, Adrian Bunk wrote:
> > It must become very good stuff when it takes Greg more than 8 months to 
> > brew it...  ;-)
> 
> Yeah, it's driver core rework, the kobject stuff was the first step to
> try to get there...
> 
> It's slow going unfortunatly other things more pressing keep popping up
> ahead of it, it's getting there...
> 
> No objection to this patch at all:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

As the subject says, it is already in Linus' tree for more than
8 months...

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

