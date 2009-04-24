Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbZDXQdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbZDXQdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758092AbZDXQdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:33:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36781 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670AbZDXQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:33:08 -0400
Message-ID: <49F1E99F.20501@zytor.com>
Date: Fri, 24 Apr 2009 09:32:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] [4/4] x86: MCE: Fix EIPV behaviour with !PCC
References: <20090407506.675031434@firstfloor.org> <20090407150657.61C4E1D046E@basil.firstfloor.org> <1240479838.6842.555.camel@yhuang-dev.sh.intel.com> <49F1077A.5030801@jp.fujitsu.com> <1240535513.6842.561.camel@yhuang-dev.sh.intel.com> <49F150BA.9040407@zytor.com> <20090424084647.GI13896@one.firstfloor.org> <49F194BC.4000704@jp.fujitsu.com>
In-Reply-To: <49F194BC.4000704@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Andi Kleen wrote:
>> On Thu, Apr 23, 2009 at 10:40:10PM -0700, H. Peter Anvin wrote:
>>> Huang Ying wrote:
>>>> On Fri, 2009-04-24 at 08:27 +0800, Hidetoshi Seto wrote:
>>>>> Huang Ying wrote:
>>>>>
>>>>> Or, should this patch be applied after committing some of Andi's patches?
>>>>> It means this patch targets a bug in Andi's patch set and the bug is not
>>>>> in 2.6.30-rc* yet.
>>>> Yes. I think you are right. I fix a "bug" that doesn't exist.
>>>>
>>> Thanks for catching that now :)
>> Sorry we still need it I think, see previous email.
> 
> ... Really?
> Still I believe this patch is not needed by .30
> 
> And, sorry, which email?
> 

I presume he was referring to your email.
Andi, right?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

