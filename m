Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbZBHMjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbZBHMjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 07:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZBHMjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 07:39:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:46232 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752346AbZBHMjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 07:39:44 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX193TkVAkJF32lVsY0pn4EIch2s/7WJmTDOha6mRs0
	W7Fn1Fg/qF4bAS
Date: Sun, 8 Feb 2009 13:39:40 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12605] Suspend regression, hang after matroxfb
Message-ID: <20090208123940.GA14450@alice>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.2UE.zuYiJB@chimera> <20090205121624.GA17811@alice> <200902051712.56407.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200902051712.56407.rjw@sisk.pl>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.29-rc3 (x86_64)
X-Uptime: 13:36:26 up  2:57, 10 users,  load average: 0.25, 0.40, 0.45
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> On Thursday 05 February 2009, Eric Sesterhenn wrote:
> > * Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.28.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12605
> > > Subject		: Suspend regression, hang after matroxfb
> > > Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
> > > Date		: 2009-01-29 12:58 (7 days old)
> > > References	: http://thread.gmane.org/gmane.linux.power-management.general/12640
> > > Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> > > Patch		: http://marc.info/?l=linux-kernel&m=123335902122029&w=4
> > 
> > with todays -git I still get the same error, I have seen that some of 
> > your PM patches got applied, seems the one I need wasnt one of them.
> 
> No, it's not been merged yet.

This is fixed with todays -git. Thanks
A CC on the newer patches would have been nice, since I read the list
only via web archives, but i saw them floating by.

Greetings, Eric
