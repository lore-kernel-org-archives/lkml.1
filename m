Return-Path: <linux-kernel-owner+w=401wt.eu-S934356AbXC2Vvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356AbXC2Vvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 17:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934359AbXC2Vvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 17:51:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54907 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934356AbXC2Vvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 17:51:45 -0400
Date: Thu, 29 Mar 2007 23:46:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4: mmc fails to work, then oopses
Message-ID: <20070329214626.GA5676@elf.ucw.cz>
References: <20070322113742.GA7198@elf.ucw.cz> <460270B8.3000006@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460270B8.3000006@drzeus.cx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > 
> > (Machine was suspended/resumed before this).
> > 
> > mount /dev/mmc1 /mnt
> > 
> 
> Driver? Reproducable? Vanilla git kernel?

It was driver for 

15:00.2 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter 

...but problem is either gone in -rc5, or not reproducible. I'll play
with it some more.
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
