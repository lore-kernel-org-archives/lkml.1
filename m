Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbZKPXgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbZKPXgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbZKPXgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:36:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60792 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645AbZKPXgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:36:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: 2.6.32-rc7-git1: Reported regressions 2.6.30 -> 2.6.31
Date: Tue, 17 Nov 2009 00:35:11 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
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
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera> <4B01E09D.3020608@lwfinger.net>
In-Reply-To: <4B01E09D.3020608@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911170035.11575.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009, Larry Finger wrote:
> On 11/16/2009 04:58 PM, Rafael J. Wysocki wrote:
> > This message contains a list of some regressions introduced between 2.6.30 and
> > 2.6.31, for which there are no fixes in the mainline I know of.  If any of them
> > have been fixed already, please let me know.
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14181
> > Subject		: b43 causes panic at ifconfig down / shutdown
> > Submitter	: Jeremy Huddleston <jeremyhu@freedesktop.org>
> > Date		: 2009-09-15 18:34 (63 days old)
> 
> This one is fixed by commit d50bae33d1358b909ade05ae121d83d3a60ab63f in
> mainline. The patch was also sent to stable.

Thanks, closed.

Rafael
