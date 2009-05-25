Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZEYXZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZEYXZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZEYXZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:25:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41369 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbZEYXZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:25:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #13331] FUTEX_LOCK_PI kills kernel
Date: Tue, 26 May 2009 01:25:44 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andreas Schwab <schwab@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera> <uSztiUhmDDC.A.0_H.h9bGKB@chimera> <1243239896.26820.648.camel@twins>
In-Reply-To: <1243239896.26820.648.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260125.44782.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009, Peter Zijlstra wrote:
> On Sun, 2009-05-24 at 21:11 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13331
> > Subject		: FUTEX_LOCK_PI kills kernel
> > Submitter	: Andreas Schwab <schwab@linux-m68k.org>
> > Date		: 2009-05-17 09:51 (8 days old)
> 
> commit 64d1304a64477629cb16b75491a77bafe6f86963
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon May 18 21:20:10 2009 +0200
> 
>     futex: setup writeable mapping for futex ops which modify user space data

Thanks, closed.

Rafael
