Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0BFJVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 04:21:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:59653 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753895Ab0BFJVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 04:21:52 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX19dV2gemutdZwEavSr/PmHG8JVbxMKWrjU2GwQ3N+
	3l0l1KS4oLA9qn
From: Sven Joachim <svenjoac@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ben Hutchings <ben@decadent.org.uk>, stable-review@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
References: <1265245849.3362.1.camel@localhost>
	<1265256174.2952.11.camel@localhost>
	<alpine.LFD.2.00.1002032135380.3707@localhost.localdomain>
	<1265272174.2952.20.camel@localhost>
	<20100204143848.GB15438@kroah.com> <87sk9gbzzt.fsf@turtle.gmx.de>
	<20100204185752.GA18595@kroah.com> <87iqacdcfj.fsf@turtle.gmx.de>
	<20100206084936.GA4441@kroah.com>
Date: Sat, 06 Feb 2010 10:21:48 +0100
In-Reply-To: <20100206084936.GA4441@kroah.com> (Greg KH's message of "Sat, 6
	Feb 2010 00:49:36 -0800")
Message-ID: <87mxzm1zyr.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.72999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-02-06 09:49 +0100, Greg KH wrote:

> I think this was the sysctl issue, and have released a 2.6.32.8-rc2.
> Can you test that to verify if it fixes your crash or not?

Yes, it fixes the issue.  I'm using -rc2 right now, did not notice any
problems so far.

Sven
