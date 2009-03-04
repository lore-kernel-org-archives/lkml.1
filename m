Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZCDBI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZCDBI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZCDBIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:08:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42440 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbZCDBIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:08:11 -0500
Date: Wed, 4 Mar 2009 02:06:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.29-rc6-git7: Reported regressions from 2.6.28
Message-ID: <20090304010645.GA28883@elte.hu>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera> <1236128626.32297.254.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236128626.32297.254.camel@rzhang-dt>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang Rui <rui.zhang@intel.com> wrote:

> On Wed, 2009-03-04 at 03:22 +0800, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12501
> > Subject         : build bug in eeepc-laptop.c
> > Submitter       : Ingo Molnar <mingo@elte.hu>
> > Date            : 2009-01-14 17:25 (49 days old)
> > References      : http://lkml.org/lkml/2009/1/14/315
> > 
> the problem has already been fixed by
> 3a5093ee6728c8cbe9c039e685fc1fca8f965048

yes - please consider it fixed.

Thanks,

	Ingo
