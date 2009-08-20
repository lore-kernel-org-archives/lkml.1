Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZHTV1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZHTV1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbZHTV1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:27:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39474 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250AbZHTV1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:27:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: John Dykstra <john.dykstra1@gmail.com>
Subject: Re: 2.6.31-rc6-git5: Reported regressions from 2.6.30
Date: Thu, 20 Aug 2009 23:28:24 +0200
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
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <1250801571.7176.10.camel@Maple>
In-Reply-To: <1250801571.7176.10.camel@Maple>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200908202328.24252.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, John Dykstra wrote:
> On Wed, 2009-08-19 at 22:20 +0200, Rafael J. Wysocki wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14002
> > Subject         : WARNING: at net/ipv4/af_inet.c:154
> > inet_sock_destruct+0x164/0x1c0()
> > Submitter       : Ralf Hildebrandt <ralf.hildebrandt@charite.de>
> > Date            : 2009-08-18 12:37 (2 days old)
> 
> That looks similar to the WARNING discussed in [1].
> 
> There was no resolution to that thread.  However, [2] points out
> possible other occurrences of the problem in 2.6.27, 28 and 29.
> 
> --  John
> 
> [1]  http://www.spinics.net/lists/netdev/msg103267.html
> [2]  http://www.spinics.net/lists/netdev/msg104120.html

Thanks for the information.

So I'll drop this from the list, since it most probably is not a recent thing.

Best,
Rafael
