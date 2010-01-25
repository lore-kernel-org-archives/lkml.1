Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320Ab0AYU4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0AYU4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644Ab0AYUz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:55:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51931 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab0AYUz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:55:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: davidjon@xenontk.org
Subject: Re: [Bug #15127] Bluetooth: sleeping function called from invalid context
Date: Mon, 25 Jan 2010 21:56:26 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.neH.KZMXLB@chimera> <4B5D27F8.6070707@xenontk.org>
In-Reply-To: <4B5D27F8.6070707@xenontk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001252156.26214.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, David John wrote:
> On 01/25/2010 03:53 AM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15127
> > Subject		: Bluetooth: sleeping function called from invalid context
> > Submitter	: David John <davidjon@xenontk.org>
> > Date		: 2010-01-12 9:19 (13 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9e726b17422bade75fba94e625cd35fd1353e682
> > References	: http://marc.info/?l=linux-kernel&m=126328727021949&w=4
> > 
> > 
> > 
> 
> Hi Rafael,
> 
> [ Corrected Luiz's email id ]

That came from a commit sign-off (better should be a correct address).

> This bug is still open.

Thanks for the update.

Rafael
