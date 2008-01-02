Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbYABAhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbYABAhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 19:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbYABAhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 19:37:40 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49863 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbYABAhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 19:37:39 -0500
Date: Wed, 2 Jan 2008 02:37:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Wolfgang Denk <wd@denx.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove broken MTD drivers
Message-ID: <20080102003724.GL27566@does.not.exist>
References: <20080101231140.GF27566@does.not.exist> <20080102002826.574C324889@gemini.denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080102002826.574C324889@gemini.denx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 01:28:26AM +0100, Wolfgang Denk wrote:
> In message <20080101231140.GF27566@does.not.exist> you wrote:
> >
> > The header of ppchameleonevb.c claims it comes from info@wawnet.biz 
> 
> Argh. That's indeed ancient code.
> 
> So what should I do to fix this? Wait for Thomas' response, or port
> patches here?

I'd say post patches, and I'd expect David to actually be the one who
reviews and incorporates them.

> Best regards,
> 
> Wolfgang Denk

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

