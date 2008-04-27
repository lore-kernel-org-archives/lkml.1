Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbYD0O3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbYD0O3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 10:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYD0O3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 10:29:03 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42853 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbYD0O3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 10:29:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48148D82.3050204@s5r6.in-berlin.de>
Date: Sun, 27 Apr 2008 16:28:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
References: <1209190455.14173.13.camel@brick>	 <20080426110044.GB2252@cs181133002.pp.htv.fi>	 <20080426075132.b0fdbe13.akpm@linux-foundation.org>	 <20080426152341.GI2252@cs181133002.pp.htv.fi>	 <20080426084420.8e61c379.akpm@linux-foundation.org>	 <20080426171604.GN2252@cs181133002.pp.htv.fi>	 <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>	 <481379BB.5050208@s5r6.in-berlin.de>	 <alpine.LFD.1.10.0804261153390.2813@woody.linux-foundation.org>	 <alpine.LFD.1.10.0804261213320.2813@woody.linux-foundation.org>	 <20080426133049.187e255c.akpm@linux-foundation.org> <1209298055.1475.0.camel@dax.rpnet.com>
In-Reply-To: <1209298055.1475.0.camel@dax.rpnet.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie wrote:
> Its worth realising that these fix patches contain useful information
> too, e.g. they might be by different authors and its also interesting in
> some senses to see what fixes were applied to the original patch, why
> etc. since it is history and that is what the SCM effectively stores.

Important things can be noted in the patch description.  We can also 
refer to mailinglist archives and bug trackers in the patch description.

Caveats:  Changing the patch description means changing the patch 
identity (which different SCMs treat with different rigor).  Also, a 
number of SCM tools assume that there is exactly one author of a patch. 
(Workaround:  Track coauthors informally in the patch description.)

...
> On the other hand I agree that the patches in -mm often have stupid
> typos etc which aren't interesting in the history but where do you draw
> the line?

Indeed.  It's the question of when do I release what to whom.
-- 
Stefan Richter
-=====-==--- -=-- ==-==
http://arcgraph.de/sr/
