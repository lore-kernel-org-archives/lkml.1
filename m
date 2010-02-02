Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab0BBUZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:25:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab0BBUY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:24:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Winchester <kjwinchester@gmail.com>
Subject: Re: [Bug #15198] Radeon KMS regression
Date: Tue, 2 Feb 2010 21:25:50 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ingo Molnar <mingo@elte.hu>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera> <d3IDKWHT5gE.A.UoB.P7hZLB@chimera> <1265069090.1515.1.camel@localhost.localdomain>
In-Reply-To: <1265069090.1515.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022125.50066.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 February 2010, Kevin Winchester wrote:
> On Mon, 2010-02-01 at 01:22 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15198
> > Subject		: Radeon KMS regression
> > Submitter	: Kevin Winchester <kjwinchester@gmail.com>
> > Date		: 2010-01-30 17:18 (2 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=42590a75019a50012f25a962246498dead428433
> > References	: http://marc.info/?l=linux-kernel&m=126487191019612&w=4
> > Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Patch		: http://patchwork.kernel.org/patch/75023/
> > 
> > 
> 
> This is fixed by the patch from FUJITA Tomonori - I just confirmed with
> my latest build of Linus' tree (which has the patch).

Thanks, already closed.

Rafael
