Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbXIXTYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbXIXTYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763010AbXIXTY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:24:28 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:40756 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759213AbXIXTY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:24:27 -0400
Date: Mon, 24 Sep 2007 15:24:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] Linux Kernel Markers (redux)
Message-ID: <20070924192425.GA2467@Krystal>
References: <20070924164950.006047409@polymtl.ca> <20070924181148.GA3285@infradead.org> <20070924190452.GE28347@Krystal> <20070924190708.GA6262@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070924190708.GA6262@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:23:04 up 56 days, 19:41,  6 users,  load average: 2.10, 1.90, 1.31
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Mon, Sep 24, 2007 at 03:04:52PM -0400, Mathieu Desnoyers wrote:
> > I provided blktrace as a first user of the markers, but I agree that it
> > may be a little late for merging. I can keep it for later too.
> 
> I we manage to get Dave's trace patches and your markers in I'll make
> sure to get a sputrace version using them in as a demo for both.
> 

Great!

So the state of the patches for next post:

kconfig-instrumentation.patch
linux-kernel-markers.patch

(yeah, only 2 patches!) :)

I'm only waiting for you guys to settle about documentation/samples
before I can repost.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
