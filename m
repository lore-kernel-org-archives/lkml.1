Return-Path: <linux-kernel-owner+w=401wt.eu-S1761505AbXKMSr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505AbXKMSr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbXKMSrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:47:15 -0500
Received: from rtr.ca ([76.10.145.34]:3650 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758597AbXKMSrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:47:12 -0500
Message-ID: <4739F12E.5020807@rtr.ca>
Date: Tue, 13 Nov 2007 13:47:10 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
References: <20071113.033946.114918709.davem@davemloft.net> <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <20071113164650.GA28493@elte.hu> <4739E3D0.10201@rtr.ca> <20071113181228.GF4250@stusta.de> <4739EA83.5040006@rtr.ca> <20071113183605.GG4250@stusta.de>
In-Reply-To: <20071113183605.GG4250@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
...
> I did bisecting myself, and I know that it costs time and work.
> 
> But the first point is the above one that it makes otherwise nearly 
> undebuggable problems debuggable and fixable.
..

Definitely useful, no question.

But the problem is now that kernel devs are addicted to it,
many won't even consider resolving a problem any other way.

That's not "maintaining" (or supporting) one's code.

And when a "maintainer" is too busy to find/fix their own bugs,
that could be a sign that they've bitten off too big of a chunk
of the kernel, and it's time for them to distribute code maintainership.

Cheers
