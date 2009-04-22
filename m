Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbZDVP6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbZDVP6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZDVP6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:58:32 -0400
Received: from mga06.intel.com ([134.134.136.21]:58505 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753430AbZDVP6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:58:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,231,1239001200"; 
   d="scan'208";a="405769569"
Message-ID: <49EF3EA2.1000505@linux.intel.com>
Date: Wed, 22 Apr 2009 17:58:26 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu> <49EEFD88.1030604@linux.intel.com> <49EF3DE2.6000201@zytor.com>
In-Reply-To: <49EF3DE2.6000201@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Andi Kleen wrote:
>> And then restart here? Add 32bit workarounds, add hook
>> to initialize p5/winchip, make 64bit code 32bit clean.
>> That can come straight from my patchkit. I can do that
>> if there is interest.
>>
> 
> Could you come up with a tree we can look at?

Will do. I'll probably need a day or so.

-Andi


