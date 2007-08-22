Return-Path: <linux-kernel-owner+w=401wt.eu-S1763465AbXHVUjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763465AbXHVUjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbXHVUjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:39:37 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25188 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982AbXHVUjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:39:36 -0400
Date: Wed, 22 Aug 2007 13:37:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: 2.6.23-rc3-mm1
Message-Id: <20070822133744.572c07c3.randy.dunlap@oracle.com>
In-Reply-To: <20070822211413.GI8058@bingen.suse.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<20070822110348.8fd6a937.randy.dunlap@oracle.com>
	<20070822113211.9ac85162.akpm@linux-foundation.org>
	<20070822193857.GC8058@bingen.suse.de>
	<20070822121731.011cd263.randy.dunlap@oracle.com>
	<20070822205311.GH8058@bingen.suse.de>
	<46CC9696.1070107@oracle.com>
	<20070822211413.GI8058@bingen.suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 23:14:13 +0200 Andi Kleen wrote:

> > Yes, that works.
> 
> Does it also work when you copy the options (except -mcmodel=kernel) 
> you see for
> 
> rm kernel/unwind.o
> make V=1 kernel/unwind.o 
> 
> to the test program command line?
> 
> If no please check which option makes it fail.

All my bad.  It's a sparse warning.  I don't know if current
sparse is fixed or not, but I'll download it.

Thanks.
---
~Randy
