Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZJIH2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZJIH2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 03:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbZJIH2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 03:28:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56993 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbZJIH2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 03:28:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ACEE5E0.3050701@jp.fujitsu.com>
Date: Fri, 09 Oct 2009 16:27:28 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] mce-inject: use injected mce only during faked handler
 call
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com> <1255072482.5228.157.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1255072482.5228.157.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> This is another example for you to use my idea, implement it in a
> similar way and send it out as your own.

I used "Reported-by:" for this patch, having some intent to indicate
that this patch uses an idea different from the original one, and that
this patch aims at the problem certainly reported by you.

> On Mon, 2009-10-05 at 11:10 +0800, Hidetoshi Seto wrote: 
>> Reported-by: Huang Ying <ying.huang@intel.com>
>> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

