Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbYEBCJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbYEBCJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 22:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbYEBCI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 22:08:58 -0400
Received: from ozlabs.org ([203.10.76.45]:37987 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYEBCI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 22:08:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18458.30641.838156.434563@cargo.ozlabs.ibm.com>
Date: Fri, 2 May 2008 12:08:49 +1000
From: Paul Mackerras <paulus@samba.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
In-Reply-To: <20080501132159.GC29330@cs181133002.pp.htv.fi>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080501003125.GM29330@cs181133002.pp.htv.fi>
	<20080430000338.50548884@infradead.org>
	<20080501113038.GW29330@cs181133002.pp.htv.fi>
	<20080430072013.7c3b30b1@infradead.org>
	<20080501132159.GC29330@cs181133002.pp.htv.fi>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk writes:

> "Kernel oops while running kernbench and tbench on powerpc" took more 
> than 2 months to get resolved, and we ship 2.6.25 with this regression.

That was a very subtle bug that only showed up on one particular
powerpc machine.  I was not able to replicate it on any of the powerpc
machines I have here.  Nevertheless, we found it and we have a fix for
it.  I think that's an example of the process working. :)

Paul.
