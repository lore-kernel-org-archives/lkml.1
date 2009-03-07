Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbZCGWO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbZCGWO5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 17:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbZCGWOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 17:14:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60615 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159AbZCGWOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 17:14:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 2.6.29-rc6-git7: Reported regressions from 2.6.28
Date: Sat, 7 Mar 2009 23:14:40 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera> <8db1092f0903041114o767d0079s4c1626dae5335d70@mail.gmail.com>
In-Reply-To: <8db1092f0903041114o767d0079s4c1626dae5335d70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903072314.41814.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 March 2009, Maciej Rutecki wrote:
> 2009/3/3 Rafael J. Wysocki <rjw@sisk.pl>:
> 
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12764
> > Subject         : Can not ioremap virtual address for G33 hw status page
> > Submitter       : Maciej Rutecki <maciej.rutecki@gmail.com>
> > Date            : 2009-02-23 14:46 (9 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6fb88588555a18792a27f483887fe1f2af5f9c9b
> > References      : http://marc.info/?l=linux-kernel&m=123540053219505&w=4
> 
> Problem seems by solved in 2.6.29-rc7

Thanks, closed.

Rafael
