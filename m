Return-Path: <linux-kernel-owner+w=401wt.eu-S940989AbXHJTDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940989AbXHJTDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765848AbXHJTDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:03:42 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:58312 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702AbXHJTDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:03:40 -0400
Date: Fri, 10 Aug 2007 22:03:38 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [3/3] 2.6.23-rc2: known regressions v2
In-Reply-To: <200708082210.25836.rjw@sisk.pl>
Message-ID: <Pine.SOC.4.64.0708102202400.13577@math.ut.ee>
References: <46B9F664.9060600@googlemail.com> <46B9F983.9020700@googlemail.com>
 <200708082210.25836.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Power management
> > 
> > Subject         : Kconfig: 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'
> > References      : http://lkml.org/lkml/2007/8/4/39
> > Last known good : ?
> > Submitter       : Meelis Roos <mroos@linux.ee>
> > Caused-By       : ?
> > Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> > Status          : unknown
> 
> I can't reproduce this with my cross compilation toolchain for PPC.

Still present with todays git and make oldconfig, on native powerpc with 
Debian unstable.

-- 
Meelis Roos (mroos@linux.ee)
