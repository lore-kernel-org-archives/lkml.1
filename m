Return-Path: <linux-kernel-owner+w=401wt.eu-S1758968AbXJLN0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968AbXJLN0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbXJLN0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:26:39 -0400
Received: from mx10.go2.pl ([193.17.41.74]:56595 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753208AbXJLN0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:26:38 -0400
Date: Fri, 12 Oct 2007 15:29:29 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071012132929.GA4013@ff.dom.local>
References: <20071012082534.GB1962@ff.dom.local> <470F337A.9090205@aitel.hist.no> <20071012091213.GC1962@ff.dom.local> <470F6C43.4090905@aitel.hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470F6C43.4090905@aitel.hist.no>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 02:44:51PM +0200, Helge Hafting wrote:
...
> The point is that we _trust_ intel when they says "this will work".
> Therefore, we can use the optimizations. It was never about
> legal matters. If we didn't trust intel, then we couldn't
> use their processors at all.

But there was nothing about trust. Usually you don't trust somebody
but somebody's opinions. The problem is there was no valid opinion,
or this opinion has been changed now (no reason to not trust yet...).

> We couldn't take the chance before. It was not documented
> to work, verification by testing would not be trivial at all for
> this case.
> Linux is about "stability first, then performance".
> Now we _know_ that we can have this optimization without
> compromising stability. Nobody knew before!

So, you think this would be the first or the least credibly
verified undocumented feature used in linux? Then, it seems
I can try to install this linux on my laptop at last! (...
And, I can trust you, it will not break anything...?)

Thanks,
Jarek P.
