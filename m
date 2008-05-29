Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYE2Nrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYE2Nrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbYE2NrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:47:18 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:58090 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371AbYE2NrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:47:17 -0400
Date: Thu, 29 May 2008 16:44:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Message-ID: <20080529134420.GA10849@cs181133002.pp.htv.fi>
References: <1211995212.3445.52.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1211995212.3445.52.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 12:20:12PM -0500, James Bottomley wrote:
>...
> The most obvious solution might be to shut the Janitors project down, or
> at least more tightly manage its TODO list (although a lot of what gets
> seen as janitorial patches, like whitespace fixes, isn't on the TODO
> list in the first place).  However, since the purpose is to get new
> people involved with kernel development, perhaps we should repurpose the
> project so it actually does this.  My suggestion is that we replace it
> with the kernel bugs project.  Kudos for finding bugs, more for finding
> better ways of finding bugs, and the most for finding and actually
> fixing a bug.  
> 
> Perhaps we should simply start the discussion with the premise that we
> want to encourage new people to do useful work and draw them into the
> development community and see where it leads.

My attempt in this direction is described at 
http://lkml.org/lkml/2008/5/7/258

Although I do not yet know how it will develop it already resulted in 
some bug reports that might otherwise not have been sent.

> James

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

