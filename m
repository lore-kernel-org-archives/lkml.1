Return-Path: <linux-kernel-owner+w=401wt.eu-S1765420AbXGKPmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765420AbXGKPmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbXGKPmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:42:08 -0400
Received: from xenotime.net ([66.160.160.81]:52313 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751601AbXGKPmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:42:07 -0400
Date: Wed, 11 Jul 2007 08:45:49 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, linux-mm@kvack.org
Subject: Re: lguest, Re: -mm merge plans for 2.6.23
Message-Id: <20070711084549.93bb433e.rdunlap@xenotime.net>
In-Reply-To: <20070711122324.GA21714@lst.de>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070711122324.GA21714@lst.de>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 14:23:24 +0200 Christoph Hellwig wrote:

...

> > lguest-the-guest-code.patch
> > lguest-the-host-code.patch
> > lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
> > lguest-the-asm-offsets.patch
> > lguest-the-makefile-and-kconfig.patch
> > lguest-the-console-driver.patch
> > lguest-the-net-driver.patch
> > lguest-the-block-driver.patch
> > lguest-the-documentation-example-launcher.patch
> 
> Just started to reading this (again) so no useful comment here, but it
> would be nice if the code could follow CodingStyle and place the || and
> && at the end of the line in multiline conditionals instead of at the
> beginning of the new one.

I prefer them at the ends of lines also, but that's not in CodingStyle,
it's just how we do it most of the time (so "coding style", without
caps).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
