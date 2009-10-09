Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbZJIFfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbZJIFfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 01:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZJIFfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 01:35:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53840 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbZJIFfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 01:35:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ACECB82.1060308@jp.fujitsu.com>
Date: Fri, 09 Oct 2009 14:34:58 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] x86, mce: make mce_log buffer to per-CPU
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com>	 <4AC990E1.7030708@jp.fujitsu.com> <4AC99483.7020100@jp.fujitsu.com>	 <4AC99AEC.3000504@linux.intel.com>  <4AC9A534.6080704@jp.fujitsu.com> <1255052730.5228.22.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1255052730.5228.22.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> I don't think it is a good collaboration style to copy others' patches,
> do some modification and send it out, instead:

Sorry, I could not stop myself since I got frustrated over a trivial matter
around this field in these days.  And I could not wait your next post any
more, didn't want to see abandoned "rebased" patch again, so I took this
kind of aggressive violent action in bad manner to push your change.
Sorry again.


> - comment on original patches

I think your patch contains various changes, so how about to break down
this one into small pieces and make patches with proper clearer description.

I believe that the urgent problem can be solved by making the buffer to
per-CPU.  Or do you have any reason to rush it into ring buffer?


> - communicate with the original author firstly

Certainly I wrote following line at first:
 > Hi Huang,


> - provide another patch on top of original patches

Since what I want to demonstrate to you was another style of your patch,
I could not provide patches in incremental form as usual.


Thanks,
H.Seto

