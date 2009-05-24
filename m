Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbZEXWU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbZEXWU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZEXWUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:20:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34396 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbZEXWUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:20:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: 2.6.30-rc7: Reported regressions from 2.6.29
Date: Mon, 25 May 2009 00:20:42 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera> <4A19C51D.7020609@pardus.org.tr>
In-Reply-To: <4A19C51D.7020609@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905250020.43820.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009, Ozan Çağlayan wrote:
> Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13326
> > Subject		: [PATCH]Null pointer dereference in rtc-cmos driver
> > Submitter	: Ozan Çağlayan <ozan@pardus.org.tr>
> > Date		: 2009-05-14 16:16 (11 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124231783704696&w=4
> >   
> 
> Just to notice that the patch for this is at:
> 
> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/driver-core.current/driver-core-do-not-oops-when-driver_unregister-is-called-for-unregistered-drivers.patch
> 
> Can at least be marked as "has a patch".

Thanks, I added the patch to the bug entry and changed its status.

Best,
Rafael
