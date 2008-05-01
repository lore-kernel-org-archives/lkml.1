Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYEAIOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYEAIOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 04:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYEAIOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 04:14:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236AbYEAIOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 04:14:30 -0400
Date: Thu, 1 May 2008 01:13:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-Id: <20080501011346.522f9846.akpm@linux-foundation.org>
In-Reply-To: <20080430000338.50548884@infradead.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080501003125.GM29330@cs181133002.pp.htv.fi>
	<20080430000338.50548884@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 00:03:38 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> > First of all:
> > I 100% agree with Andrew that our biggest problems are in reviewing
> > code and resolving bugs, not in finding bugs (we already have far too
> > many unresolved bugs).
> 
> I would argue instead that we don't know which bugs to fix first.

<boggle>

How about "a bug which we just added"?  One which is repeatable. 
Repeatable by a tester who is prepared to work with us on resolving it. 
Those bugs.

Rafael has a list of them.  We release kernels when that list still has tens of
unfixed regressions dating back up to a couple of months.

