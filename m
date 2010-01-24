Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122Ab0AXXja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0AXXja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181Ab0AXXj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:39:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab0AXXj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:39:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [Bug #14625] Commit d451564 breaks ARM
Date: Mon, 25 Jan 2010 00:39:50 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Soeren Sandmann <sandmann@daimi.au.dk>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.5sB.QbMXLB@chimera> <20100124232912.GA10805@flint.arm.linux.org.uk>
In-Reply-To: <20100124232912.GA10805@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001250039.50622.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Russell King wrote:
> On Sun, Jan 24, 2010 at 11:22:52PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> 
> Fixed by 4ff1fa2.

Thanks, closing.

Rafael
