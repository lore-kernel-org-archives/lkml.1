Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0CIL2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 06:28:40 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:36042
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754070Ab0CIL2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 06:28:38 -0500
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dN936eM4015L62a3Lzz1202hzzz32i6bh2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KZ0III-02-1ZI-02
X-M-MSG: 
Date: Tue, 9 Mar 2010 12:27:52 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT PULL] oprofile: updates for v2.6.34
Message-ID: <20100309112752.GG3650@erda.amd.com>
References: <20100302164405.GJ13205@erda.amd.com>
 <20100304105005.GA21977@elte.hu>
 <20100304174422.GQ13205@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100304174422.GQ13205@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 09 Mar 2010 11:27:53.0128 (UTC) FILETIME=[8ECECA80:01CABF7B]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.03.10 18:44:22, Robert Richter wrote:
> On 04.03.10 11:50:05, Ingo Molnar wrote:
> > 
> > * Robert Richter <robert.richter@amd.com> wrote:
> > 
> > > Ingo,
> > > 
> > > it's only one patch, please pull from:
> > > 
> > >  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> > > 
> > > (It seems the git mirror is not yet sync'ed.)
> > 
> > Still cannot pull - forgot to push out?
> 
> No, it is already out, at least it is available now:
> 
>  http://git.kernel.org/?p=linux/kernel/git/rric/oprofile.git;a=shortlog;h=refs/heads/urgent

Ingo,

can you try to send that one patch in urgent upstream for .34? It is
already in the queue for 1 week.

Could you also pull the oprofile core tree with the reservation code
to tip/oprofile? I also want to merge this to perf/core after pending
perf patches esp. pebs are applied to tip. When do you think perf/core
can be updated?

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

