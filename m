Return-Path: <linux-kernel-owner+w=401wt.eu-S1760514AbXJLKBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514AbXJLKBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 06:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbXJLKB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 06:01:27 -0400
Received: from mx10.go2.pl ([193.17.41.74]:54849 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750906AbXJLKB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 06:01:26 -0400
Date: Fri, 12 Oct 2007 12:04:18 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nick Piggin <npiggin@suse.de>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071012100418.GE1962@ff.dom.local>
References: <20071012082534.GB1962@ff.dom.local> <470F337A.9090205@aitel.hist.no> <20071012091213.GC1962@ff.dom.local> <20071012094427.GC19237@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012094427.GC19237@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 11:44:27AM +0200, Nick Piggin wrote:
...
> So unless there is reasonable information for us to believe this
> will be a problem, IMO the best thing to do is stick with the
> specs. Intel is pretty reasonable with documenting errata I think.

100% right - if there are any specs. But it seems for a few years
this spec was missing or there is some change of mind, I presume?

Jarek P.
