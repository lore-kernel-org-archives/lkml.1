Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbZHUWBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbZHUWBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 18:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932864AbZHUWBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 18:01:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44021 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243AbZHUWBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 18:01:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: 2.6.31-rc6-git5: Reported regressions from 2.6.30
Date: Sat, 22 Aug 2009 00:02:03 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
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
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <4A8F12CE.9090601@lwfinger.net>
In-Reply-To: <4A8F12CE.9090601@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908220002.03707.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 August 2009, Larry Finger wrote:
> Rafael J. Wysocki wrote:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13960
> > Subject		: rtl8187 not connect to wifi
> > Submitter	: okias <d.okias@gmail.com>
> > Date		: 2009-08-10 19:16 (10 days old)
> 
> The patch for this one was sent from Linville to DaveM earlier today,
> and should be sent to mainline in the near future.
> 
> AFAIK, the OP has not yet tested the patch, but I think I was able to
> reproduce the problem, and the patch did fit it for me.

Thanks for the update.

Can you please close the bug when the patch is merged?

Rafael
