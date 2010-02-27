Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030767Ab0B0UEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 15:04:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42363 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030726Ab0B0UEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 15:04:39 -0500
Message-ID: <4B8979DA.9000201@zytor.com>
Date: Sat, 27 Feb 2010 12:00:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] x86: Add optimized popcnt variants
References: <20100222184945.GD21233@aftab> <4B82E144.1050007@zytor.com> <20100223155852.GF30382@aftab> <4B84118C.90203@zytor.com> <20100223175457.GA2401@aftab> <4B841BC3.1000908@zytor.com> <20100223190614.GB2401@aftab> <4B875BBD.4060104@zytor.com> <20100226074714.GA15310@aftab> <4B88097E.7010608@zytor.com> <20100227082807.GA21706@aftab>
In-Reply-To: <20100227082807.GA21706@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2010 12:28 AM, Borislav Petkov wrote:
> 
>> I guess, on the other hand, if it ends up not getting merged until .35
>> it's not a huge deal either.
> 
> Yeah, let's give it another round of testing and queue it for .35 -
> AFAIR Ingo runs also a wide testing effort so it spending another cycle
> in -tip and being hammered on by us could give us a bit more certainty.
> 

Yes, if we can get into -tip then we'll get more test coverage, so I'll
queue it up for .35 as soon as the merge window closes.  Please remind
me if I forget.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

