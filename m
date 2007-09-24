Return-Path: <linux-kernel-owner+w=401wt.eu-S1760647AbXIXSpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647AbXIXSpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbXIXSpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:45:18 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:46332 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756188AbXIXSpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:45:16 -0400
Date: Mon, 24 Sep 2007 14:45:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 5/7] Linux Kernel Markers - Use instrumentation kconfig menu
Message-ID: <20070924184514.GC28347@Krystal>
References: <20070924164950.006047409@polymtl.ca> <20070924165428.009275376@polymtl.ca> <20070924174924.GC1608@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070924174924.GC1608@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:44:32 up 56 days, 19:03,  6 users,  load average: 1.32, 1.45, 1.18
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> Subject and description sounds rather odd for just wiring up Kconfig
> and Makefile.  I'd suggest merging this into the previous patch.
> In fact given how small markers are it might make sense to put the
> documentation into it aswell, it's probably still a lot below 400k.
> 

Good point, let's do it.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
