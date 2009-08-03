Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbZHCP3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbZHCP3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZHCP3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:29:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42251 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbZHCP3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:29:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: 2.6.31-rc5: Reported regressions from 2.6.30
Date: Mon, 3 Aug 2009 17:29:37 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <alpine.LFD.2.01.0908021456430.3352@localhost.localdomain> <19062.48839.950183.569219@pilspetsen.it.uu.se>
In-Reply-To: <19062.48839.950183.569219@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031729.38467.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Mikael Pettersson wrote:
> (cc:s trimmed)
> 
> Linus Torvalds writes:
>  > 
>  > 
>  > On Sun, 2 Aug 2009, Rafael J. Wysocki wrote:
>  > > 
>  > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13896
>  > > Subject		: 2.6.31-rc4 broke expect and gcc's testsuite
>  > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
>  > > Date		: 2009-07-29 11:00 (5 days old)
>  > > References	: http://marc.info/?l=linux-kernel&m=124885806406520&w=4
>  > 
>  > I bet this is the same tty bug that got fixed by Ogawa in commit 
>  > e043e42bdb. -rc5 has that fix. Mikael?
> 
> I didn't identify the actual commit, but yes, 2.6.31-rc5 makes
> gcc's testsuite work again.

Great!  I've closed the bug.

Thanks,
Rafael
