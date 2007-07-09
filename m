Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbXGIJkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbXGIJkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbXGIJk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:40:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:39549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbXGIJkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:40:25 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
Date: Mon, 9 Jul 2007 11:39:25 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070617214231.GA3588@stusta.de> <200707090102.21784.ak@suse.de> <20070708231726.GW3492@stusta.de>
In-Reply-To: <20070708231726.GW3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707091139.25240.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > It will be solved differently longer term, but short term the fix
> > was still needed. There are limits on what can be done late 
> > in the release cycle so simple patches win.
> 
> Your patch got into Linus' tree in the middle of the merge window...

Even in the middle of the merge window it might be too late
to do some large scale restructuring (as would have been needed
for this particular issue) 

Merge window is basically for about finished patches, not for development.

-Andi

