Return-Path: <linux-kernel-owner+w=401wt.eu-S1765624AbYEATqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765624AbYEATqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbYEATqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:46:15 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52317 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969AbYEATqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:46:14 -0400
Date: Thu, 1 May 2008 22:45:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andres Freund <andres@anarazel.de>
Cc: linux-kernel@vger.kernel.org, apdim@grecian.net,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] v4l/dvb: Add linux/version.h include as KERNEL_VERSION
	macro is used.
Message-ID: <20080501194526.GP29330@cs181133002.pp.htv.fi>
References: <200805012005.42400.andres@anarazel.de> <20080501193107.GN29330@cs181133002.pp.htv.fi> <200805012136.03569.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200805012136.03569.andres@anarazel.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 09:36:02PM +0200, Andres Freund wrote:
> On Thursday 01 May 2008, Adrian Bunk wrote in "Re: [PATCH] v4l/dvb: Add 
> linux/version.h include as KERNEL_VERSION macro is used.":
> > The #include is already there a dozen lines below.
> Hm. Strange.
> It fixed a build error for me. Will retest and report back.

That's why I said:

It seems to be missing in another file.
Can you send the error message and your .config?

> Andres

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

