Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbXLJNeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbXLJNeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 08:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbXLJNd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 08:33:57 -0500
Received: from brick.kernel.dk ([87.55.233.238]:11838 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbXLJNd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 08:33:57 -0500
Date: Mon, 10 Dec 2007 14:30:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Message-ID: <20071210133050.GJ5008@kernel.dk>
References: <200712051603.02183.phillips@phunq.net> <200712100504.15865.phillips@phunq.net> <20071210131901.GI5008@kernel.dk> <200712100526.49319.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712100526.49319.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10 2007, Daniel Phillips wrote:
> On Monday 10 December 2007 05:19, Jens Axboe wrote:
> > Precisely. So forgive me for thinking this patch hasn't seen very
> > varied testing, that's 2 errors (one simple, one bad - broken was NOT
> > a gross exageration, thanks) in very few lines.
> 
> See the [RFC]?  If I had meant Request For Flaming, I would have written 
> that.  Thankyou for the catch.

The same mail that contained this part, copied verbatim:

"Let me close with perhaps the most relevant remarks: the attached code
 has been in heavy testing and in production for months now.  Thus there
 is nothing theoretical when I say it works, and the patch speaks for
 itself in terms of obvious correctness."

We must have differing opinions on what obvious correctness is.

Future replies to /dev/null, please.

-- 
Jens Axboe

