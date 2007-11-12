Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbXKLRer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbXKLRer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbXKLRej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:34:39 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43011 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755261AbXKLRej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:34:39 -0500
Date: Mon, 12 Nov 2007 18:34:16 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [poll] Is the megafreeze development model broken?
Message-ID: <20071112173416.GO9771@stusta.de>
References: <fgtfqa$h9j$1@ger.gmane.org> <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com> <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi> <20071112152057.GJ9771@stusta.de> <20071112160254.GA31972@jolt.modeemi.cs.tut.fi> <20071112165616.GM9771@stusta.de> <20071112171626.GA8838@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071112171626.GA8838@jolt.modeemi.cs.tut.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 07:16:26PM +0200, Tuomo Valkonen wrote:
> On 2007-11-12 17:56 +0100, Adrian Bunk wrote:
> > Yes, by asking immediately
> >   Is this issue still present with $latest_upstream_version?
> 
> That's still a user complaining about problems fixed ages ago,
> and a couple more who never even bothered complaining, just
> decided that the software is crap because it doesn't work.
> 
> > Let's check your statement against reality:
> > 
> > They are called linux-*
> 
> I have various kernel-image packages.
>...

Either they are empty transition packages depending on the linux-* 
packages or you are not using Debian stable but Debian oldstable (the 
latter would be funny in the context of your complaints...).

> Tuomo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

