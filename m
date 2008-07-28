Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbYG1SHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbYG1SHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYG1SHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:07:39 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47754 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753250AbYG1SHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:07:38 -0400
Message-ID: <488E0AE9.4030007@sgi.com>
Date: Mon, 28 Jul 2008 11:07:37 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] cpus4096 fixes
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <200807281042.12860.rusty@rustcorp.com.au> <20080728083311.GA30302@elte.hu>
In-Reply-To: <20080728083311.GA30302@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
>> Hey, since Mike put his Signed-off-by above mine and didn't put a From 
>> line when he took my patch, WFT am I taking responsibility? :)
> 
> hm, Mike, please dont do that. You changed Rusty's patch but the way we 
> do that is to preserve the original change and then do a delta patch. If 
> you dont want to split a commit you should keep the original From and 
> mention your own changes in the changelog. I know this was all in the 
> rush to meet -rc1, but still.
> 
> 	Ingo


Yes, sorry, as I mentioned I wasn't aware of the correct thing to do.  And
as you've mentioned, a lot of this has been under pressure because 2.6.27
will be the kernel that the distros use when this system comes online.  So
time is the one thing we (SGI) do not have.  That's not to say that doing it
wrong is ok, it's just that sometimes what I might think is trivial (ie.,
builds and functions correctly) might not be to others, and I welcome comments,
suggestions, reviews, criticism, ideas, whatever.  As I've mentioned I am
new to this "arena" of development.

And again, thanks for the comments and feedback, it has been an enlightening
10 months. ;-)

Mike
