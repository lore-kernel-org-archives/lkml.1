Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbYEAJ1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbYEAJ1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 05:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbYEAJ05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 05:26:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60819 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753939AbYEAJ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 05:26:56 -0400
Date: Thu, 1 May 2008 10:17:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501101743.0136e864@core>
In-Reply-To: <48194464.2000406@garzik.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org>
	<18457.219.995207.136771@cargo.ozlabs.ibm.com>
	<alpine.LFD.1.10.0804302034180.5994@woody.linux-foundation.org>
	<48194464.2000406@garzik.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - opens all the debates about running parallel branches, such as, would 
> it be better to /branch/ for 2.6.X-rc, and then keep going full steam on 
> the trunk?  After all, the primary logic behind 2.6.X-rc is to only take 

That encourages developers to continue ignoring that stabilizing work.
The stall does have a side effect of refocussing them. A branch for -rc
and a monthly cycle would be interesting as it would mean that the
pushback for not fixing stability problems would be not getting you work
pulled for the main tree if you didn't fix the bugs first - and could be
both sufficient an incentive and not too vicious as it would be with a 2
month cycle.

Alan
