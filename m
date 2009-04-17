Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbZDQVbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbZDQVbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbZDQVbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:31:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43028 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbZDQVbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:31:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
Date: Fri, 17 Apr 2009 23:31:05 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <alpine.LFD.2.00.0904161742140.4042@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904161742140.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904172331.06910.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 April 2009, Linus Torvalds wrote:
> 
> On Thu, 16 Apr 2009, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13098
> > Subject		: 2.6.29-git12 breaks vga=0x0f07 on MSI/Intel GPU
> > Submitter	: Andi Kleen <andi@firstfloor.org>
> > Date		: 2009-04-06 01:14 (11 days old)
> > References	: http://lkml.org/lkml/2009/4/5/200
> > Handled-By	: H. Peter Anvin <hpa@zytor.com>
> 
> I think this got fixed already. The VGA moresettign was reverted back to 
> the old order.

Closed.

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13044
> > Subject		: 2.6.30-rc1 can't find the root fs
> > Submitter	: Heinz Diehl <htd@fancy-poultry.org>
> > Date		: 2009-04-08 13:35 (9 days old)
> 
> This was one of the async things that got fixed by just waiting for module 
> async work to finish.

Closed.

Thanks,
Rafael
