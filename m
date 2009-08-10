Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZHJUxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZHJUxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbZHJUxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:53:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49517 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbZHJUxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:53:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Rogge <marogge@onlinehome.de>
Subject: Re: [Bug #13945] Kernel freezes dual pentium-3 system
Date: Mon, 10 Aug 2009 22:54:02 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "devzero" <devzero@web.de>
References: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera> <pRuaDVjxFBG.A.plE.YD2fKB@chimera> <200908102057.55825.marogge@onlinehome.de>
In-Reply-To: <200908102057.55825.marogge@onlinehome.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908102254.02706.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009, Martin Rogge wrote:
> On Sunday 09 August 2009 23:10:35 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13945
> > Subject		: Kernel freezes dual pentium-3 system
> > Submitter	: Martin Rogge <marogge@onlinehome.de>
> > Date		: 2009-08-03 16:25 (7 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124931667320530&w=4
> 
> Hi Rafael,
> 
> yes the regression should still be listed. You may want to merge the bugzilla 
> IDs 13945 and 13933 as they both refer to the same issue.

I closed bug #13945 as a duplicate of bug #13933 and added the latter to the
list of post-2.6.29 regressions.

Thanks,
Rafael
