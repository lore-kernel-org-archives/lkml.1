Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbZEQKX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbZEQKX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 06:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZEQKXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 06:23:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46304 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbZEQKXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 06:23:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #13172] Spontaneous reboots since 2.6.29-rc*
Date: Sun, 17 May 2009 12:23:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.QrG.PA0DKB@chimera> <8db1092f0905170053k5ccd8903k7b6d203dd349daeb@mail.gmail.com>
In-Reply-To: <8db1092f0905170053k5ccd8903k7b6d203dd349daeb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905171224.00249.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009, Maciej Rutecki wrote:
> 2009/5/16 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13172
> > Subject         : Spontaneous reboots since 2.6.29-rc*
> > Submitter       : Maciej Rutecki <maciej.rutecki@gmail.com>
> > Date            : 2009-04-17 17:03 (30 days old)
> > References      : http://marc.info/?l=linux-kernel&m=123998788921733&w=4
> >
> >
> 
> I try:
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> 
> from:
> http://marc.info/?l=linux-kernel&m=124022460715035&w=4
> 
> Spontaneous reboots occur less often than in previous .config. From
> last report it occur once or twice. I think, it's hardware/bios/mtrr
> issue.
> 
> Because of this I think we should remove this regression from list,
> until I find out, why it happen, or more people report this. What do
> You think?

I've closed the bug.  Pleaes reopen it once you've found the root cause.

Thanks,
Rafael
