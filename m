Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbZCGWHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbZCGWHa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 17:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbZCGWHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 17:07:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60545 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbZCGWHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 17:07:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: 2.6.29-rc6-git7: Reported regressions from 2.6.28
Date: Sat, 7 Mar 2009 23:06:56 +0100
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
References: <KiHv0irKPzE.A.l3.hUarJB@chimera> <1236128626.32297.254.camel@rzhang-dt>
In-Reply-To: <1236128626.32297.254.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903072306.57060.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 March 2009, Zhang Rui wrote:
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

Thanks, closed.

Rafael
