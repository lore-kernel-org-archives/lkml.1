Return-Path: <linux-kernel-owner+w=401wt.eu-S1758474AbZJLVnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbZJLVnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbZJLVnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:43:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36364 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575AbZJLVnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:43:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: 2.6.32-rc4: Reported regressions 2.6.30 -> 2.6.31
Date: Mon, 12 Oct 2009 23:43:48 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <4AD26926.9030306@lwfinger.net>
In-Reply-To: <4AD26926.9030306@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122343.48373.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Larry Finger wrote:
> On 10/11/2009 05:41 PM, Rafael J. Wysocki wrote:
> > [Note:
> >   10 new reports in the last 10 days, but fortunately we're fixing them faster
> >   than they're being reported.]
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14181
> > Subject		: b43 causes panic at ifconfig down / shutdown
> > Submitter	: Jeremy Huddleston <jeremyhu@freedesktop.org>
> > Date		: 2009-09-15 18:34 (27 days old)
> 
> A patch to fix this one is in the hands of the OP. It should be tested
> within the next couple of days.

Great, thanks for the update.

Rafael
