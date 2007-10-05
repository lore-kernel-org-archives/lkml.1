Return-Path: <linux-kernel-owner+w=401wt.eu-S1763383AbXJEQFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383AbXJEQFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbXJEQFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:05:31 -0400
Received: from mx1.suse.de ([195.135.220.2]:41738 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242AbXJEQFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:05:30 -0400
From: Andi Kleen <ak@suse.de>
To: "David Bahi" <dbahi@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
Date: Fri, 5 Oct 2007 18:03:31 +0200
User-Agent: KMail/1.9.1
Cc: mingo@elte.hu, arjan@infradead.org, tglx@linutronix.de,
       akpm@linux-foundation.org, "Gregory Haskins" <GHaskins@novell.com>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
References: <47060B680200006C00019B7B@sinclair.provo.novell.com>
In-Reply-To: <47060B680200006C00019B7B@sinclair.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710051803.32016.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> If it's agreed that this is the fix - can you submit a proper [PATCH] so
> all users of watchdog_use_timer_and_hpet_on_x86_64.patch can be removed,
> and replaced with yours.

ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/watchdog-fix

-Andi

