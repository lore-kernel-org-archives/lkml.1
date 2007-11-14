Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbXKNSYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbXKNSYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbXKNSYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:24:12 -0500
Received: from mail.fieldses.org ([66.93.2.214]:47131 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbXKNSYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:24:10 -0500
Date: Wed, 14 Nov 2007 13:23:51 -0500
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071114182351.GI14254@fieldses.org>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071113.033946.114918709.davem@davemloft.net> <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <20071113085514.3414aa52.rdunlap@xenotime.net> <20071114140847.GA11489@elte.hu> <20071114093820.ff3ad8f9.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114093820.ff3ad8f9.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 09:38:20AM -0800, Randy Dunlap wrote:
> On Wed, 14 Nov 2007 15:08:47 +0100 Ingo Molnar wrote:
> > so please stop this "too busy and too noisy" nonsense already. It was 
> > nonsense 10 years ago and it's nonsense today. In 10 years the kernel 
> > grew from a 1 million lines codebase to an 8 million lines codebase, so 
> > what? Deal with it and be intelligent about filtering your information 
> > influx instead of imposing a hard pre-filtering criteria that restricts 
> > intelligent processing of information.
> 
> So you have a preferred method of handling email.  Please don't
> force it on the rest of us.

I'd be curious for any pointers on tools, actually.  I "read" (ok, skim)
lkml but still overlook relevant bug reports occasionally.
(Fortunately, between Trond and Andrew and others forwarding things it's
not actually a problem, but I'm still curious).

--b.
