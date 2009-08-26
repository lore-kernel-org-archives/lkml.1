Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZHZULO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZHZULO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZHZULN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:11:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35842 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZHZULL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:11:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: 2.6.31-rc7-git2: Reported regressions 2.6.29 -> 2.6.30
Date: Wed, 26 Aug 2009 22:11:39 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera> <b170af450908260147o60427997ne6b9872198893c41@mail.gmail.com>
In-Reply-To: <b170af450908260147o60427997ne6b9872198893c41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908262211.39228.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, Rafał Miłecki wrote:
> 2009/8/25 Rafael J. Wysocki <rjw@sisk.pl>:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13514
> > Subject         : acer_wmi causes stack corruption
> > Submitter       : Rus <harbour@sfinx.od.ua>
> > Date            : 2009-06-12 08:13 (75 days old)
> 
> It has patch, just Len doesn't seem to... don't know, read the topic?
> http://patchwork.kernel.org/patch/29082/
> 
> Can we ping Len somehow to push this patch directly to Linus's tree?

I have updated the bug entry, hopefully Len will notice it now.

Thanks,
Rafael
