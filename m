Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZJRSdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZJRSdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 14:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbZJRSdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 14:33:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39897 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbZJRSdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 14:33:46 -0400
Date: Sat, 17 Oct 2009 19:09:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:bkl/drivers] drivers: Remove BKL from misc_open
Message-ID: <20091017170946.GC1526@ucw.cz>
References: <20091010153349.237173041@linutronix.de> <alpine.LFD.2.00.0910141816020.9428@localhost.localdomain> <200910141854.49418.arnd@arndb.de> <200910141912.40190.arnd@arndb.de> <alpine.LFD.2.00.0910142136010.9428@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910142136010.9428@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!!

> > > drivers/staging/android/binder.c
> > > drivers/staging/dream/qdsp5/audio_aac.c
> > > drivers/staging/dream/qdsp5/audio_evrc.c
> > > drivers/staging/dream/qdsp5/audio_in.c
> > > drivers/staging/dream/qdsp5/audio_out.c
> > > drivers/staging/dream/qdsp5/snd.c
> > > drivers/staging/dream/smd/smd_qmi.c
> > > drivers/staging/panel/panel.c
> 
> More sigh.

I guess you can just pretend these do not exist.
							Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
