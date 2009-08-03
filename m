Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbZHCU5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbZHCU5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZHCU5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:57:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43588 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbZHCU5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:57:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Bug #13726] fio sync read 4k block size 35% regression
Date: Mon, 3 Aug 2009 22:58:16 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.1IE.wdgdKB@chimera> <alpine.DEB.2.01.0908031323220.5831@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.0908031323220.5831@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908032258.17360.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Christian Kujau wrote:
> On Sun, 2 Aug 2009 at 20:58, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13726
> > Subject		: fio sync read 4k block size 35% regression
> > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date		: 2009-07-01 11:25 (33 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=51daa88ebd8e0d437289f589af29d4b39379ea76
> > References	: http://lkml.org/lkml/2009/6/30/679
> > Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
> 
> Not sure if the regression is gone, but the submitter wants to:
> 
>    http://bugzilla.kernel.org/show_bug.cgi?id=13726#c2
>    > I would like to close the report now. If finding new issues with
>    > new revised test cases, I will open new reports.

OK, closed.

Thanks,
Rafael
