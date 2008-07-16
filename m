Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYGPBz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYGPBz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 21:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYGPBzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 21:55:49 -0400
Received: from ax54.genwebserver.com ([72.18.156.50]:53973 "EHLO
	ax54.genwebserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYGPBzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 21:55:49 -0400
Message-ID: <487D547C.7060909@assumpcao.org>
Date: Tue, 15 Jul 2008 22:53:00 -0300
From: Tiago Assumpcao <tiago@assumpcao.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Tiago Assumpcao <tiago@assumpcao.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, pageexec@freemail.hu,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
References: <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org> <487D3C17.31467.1C3C0441@pageexec.freemail.hu> <alpine.LFD.1.10.0807151620450.2867@woody.linux-foundation.org> <487D3A13.3040507@assumpcao.org> <20080716010836.GL8185@mit.edu>
In-Reply-To: <20080716010836.GL8185@mit.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ax54.genwebserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - assumpcao.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> Look if you want this, pay $$$ to a distribution and get their
> supported distribution.  It costs time and effort to classify bugs as
> security related (or not), (...)

That's fallacious. Assuming that you have good programmers, and you do, 
it's of very low cost the act of identifying what *is likely to be* a 
security bug. In most cases, they are easy to spot. And, hey, we are not 
asking for an absurd amount of care. You must not pay $200 /hour for 
someone to review your software. All I, personally, ask for is that the 
basic attention is given. With this simple act, I'm sure you would cover 
the majority of the bugs.

> It will cost you money, but hey, the people who want
> this sort of thing typically are willing to pay for the service.
> 

So, only those willing to pay have the right of respect? Because, you 
see, this is rather a matter of respect with those who choose to use 
your solution. And, no, the "free will" argument does not qualify 
herein. My mother is not aware of your absurd acts.

> I'll note that trying to classify bugs as being "security-related" at
> the kernel.org level often doesn't help the distro's, since many of
> these bugs won't even apply to whatever version of the kernel the
> distro's snapshotted 9-18 months ago.  So if the distro snapshotted
 > 2.6.18 in Fall 2006, and their next snapshot will be sometime two
> years later in the fall of this year, they will have no use for some
> potential local denial of service attack that was introduced by
> accident in 2.6.24-rc3, and fixed in 2.6.25-rc1.  It just doesn't
> matter to them.

I don't follow what you have just said. What is the problem with 
"versioning" and the strictness of its relation to bugs, security or not?

> 
> So basically, if there are enough kernel.org users who care, they can
> pay someone to classify and issue CVE numbers for each and every
> potential "security bug" that might appear and then disappear.

I think, CVE registration or the alike would be too much for what I call 
"act of decency". A single parenthesis note on the bug itself would be 
of great help and of small effort.


--t







