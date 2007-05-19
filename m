Return-Path: <linux-kernel-owner+w=401wt.eu-S1763602AbXESQpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763602AbXESQpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 12:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbXESQpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 12:45:12 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:49991 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbXESQpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 12:45:10 -0400
Date: Sun, 20 May 2007 01:43:29 +0900
From: Mattia Dongili <malattia@linux.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: 2.6.22-rc1 regression: tifm prevents suspending [was: Re: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after STR]
Message-ID: <20070519164329.GA3224@inferi.kami.home>
References: <20070518071523.GA3195@inferi.kami.home> <20070518002240.bc08e811.akpm@linux-foundation.org> <20070519064829.GA15518@inferi.kami.home> <20070519000413.75badb6f.akpm@linux-foundation.org> <20070519151110.GA3393@inferi.kami.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070519151110.GA3393@inferi.kami.home>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc1-mm1-bisect i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 12:11:10AM +0900, Mattia Dongili wrote:
...
> I'm now seeing if avoiding the tifm stuff in -mm1 fixes the
> immediately-resumes-after-str problem (unfortunately the commint doesn't
> revert cleanly).

as (almost) expected it is not related... tomorrow is another bisecting
day...

-- 
mattia
:wq!
