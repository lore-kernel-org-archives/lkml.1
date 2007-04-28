Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbXD1Ush@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbXD1Ush (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbXD1Ush
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:48:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43921 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754835AbXD1Usf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:48:35 -0400
Date: Sat, 28 Apr 2007 22:47:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/2] Separate freezer from PM code (rev. 2)
Message-ID: <20070428204751.GB3389@elf.ucw.cz>
References: <200704281135.56275.linux-kernel-owner@vger.kernel.org> <200704281137.23195.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704281137.23195.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-04-28 11:37:22, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Now that the freezer is used by kprobes, it is no longer a PM-specific piece of
> code.  Move the freezer code out of kernel/power and introduce the
> CONFIG_FREEZER option that will be chosen automatically if PM or KPROBES is
> set.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Still acked :-)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
