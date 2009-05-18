Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbZERSDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbZERSDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 14:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbZERSDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 14:03:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56625 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbZERSDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 14:03:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Justin Madru <jdm64@gawab.com>
Subject: Re: [Bug #13188] horizontal strips of the screen frozen
Date: Mon, 18 May 2009 20:03:09 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.hMB._YzDKB@chimera> <4A118E36.40204@gawab.com>
In-Reply-To: <4A118E36.40204@gawab.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905182003.09876.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 May 2009, Justin Madru wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13188
> > Subject		: horizontal strips of the screen frozen
> > Submitter	: Justin Madru <jdm64@gawab.com>
> > Date		: 2009-04-24 20:59 (23 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=280b713b5b0fd84cf2469098aee88acbb5de859c
> > References	: http://marc.info/?l=linux-kernel&m=124060685315937&w=4
> >
> >
> >
> >   
> As far as I can tell, this seams to be fixed by the intel-2.7.1 driver, 
> and the bug only happened with UXA.
> I did some minor testing and I couldn't trigger the bug. (earlier 
> discussion in http://lkml.org/lkml/2009/4/23/587)
> So this seams to be a user space bug, fixed in the intel-2.7.1 bug fix 
> release (intel-2.7.0 still has the issue).

I have closed the bug.

Thanks,
Rafael
