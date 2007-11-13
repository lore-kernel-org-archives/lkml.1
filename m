Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbXKMUOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbXKMUOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbXKMUNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:13:44 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58887 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753288AbXKMUNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:13:43 -0500
Date: Tue, 13 Nov 2007 21:13:19 +0100
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       alsa-devel@alsa-project.org, netdev@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       protasnb@gmail.com, linux-ide@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113201319.GL4250@stusta.de>
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113.043207.44732743.davem@davemloft.net> <20071113193219.GC1356@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071113193219.GC1356@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 07:32:19PM +0000, Russell King wrote:
>...
> There's another issue I want to raise concerning bugzilla.  We have the
> classic case of "not enough people reading bugzilla bugs" - which is one
> of the biggest problems with bugzilla.  Virtually no one in the ARM
> community looks for ARM bugs in bugzilla.
> 
> Let's not forget that it would be a waste of time for people to manually
> check bugzilla for ARM bugs.  There's soo few people reporting ARM bugs
> into bugzilla that a weekly manual check by every maintainer would just
> return the same old boring results for months and months at a time.
>...

What about having all ARM bugs in Bugzilla by default assigned to 
linux-arm-kernel@lists.arm.linux.org.uk? [1]

> Russell King

cu
Adrian

[1] Either directly or through a pseudo address, but that's just a
    technical detail.

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

