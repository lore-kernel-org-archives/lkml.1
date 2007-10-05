Return-Path: <linux-kernel-owner+w=401wt.eu-S1761332AbXJERlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332AbXJERlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 13:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbXJERk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 13:40:56 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:37100 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449AbXJERkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 13:40:55 -0400
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Andi Kleen <ak@suse.de>
Cc: David Bahi <dbahi@novell.com>, mingo@elte.hu, arjan@infradead.org,
       tglx@linutronix.de, akpm@linux-foundation.org,
       Gregory Haskins <GHaskins@novell.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <200710051803.32016.ak@suse.de>
References: <47060B680200006C00019B7B@sinclair.provo.novell.com>
	 <200710051803.32016.ak@suse.de>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Fri, 05 Oct 2007 11:38:12 -0600
Message-Id: <1191605892.31605.198.camel@hermosa.morrealenet>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-05 at 18:03 +0200, Andi Kleen wrote:
> > If it's agreed that this is the fix - can you submit a proper [PATCH] so
> > all users of watchdog_use_timer_and_hpet_on_x86_64.patch can be removed,
> > and replaced with yours.
> 
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/watchdog-fix
> 
> -Andi
> 

Hummm, a directory appears to be protected, or DNE.  I get  "failed to
change directory". 

Thx,
-PWM



