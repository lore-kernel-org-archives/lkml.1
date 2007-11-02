Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbXKBB0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbXKBB0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXKBB0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:26:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39247 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbXKBB0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:26:34 -0400
Message-ID: <472A7CA7.4060408@zytor.com>
Date: Thu, 01 Nov 2007 18:25:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       mingo@redhat.com, torvalds@linux-foundation.org, adaplas@pol.net,
       ak@suse.de, ebiederm@xmission.com, mouli@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 -v2 resend] x86_64 EFI boot support
References: <1193218342.23935.147.camel@caritas-dev.intel.com>	<1193793701.23935.394.camel@caritas-dev.intel.com> <20071031125907.ba953d4a.akpm@linux-foundation.org> <4728E0DE.7080702@zytor.com> <9D7649D18729DE4BB2BD7B494F7FEDC295BE97@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <9D7649D18729DE4BB2BD7B494F7FEDC295BE97@pdsmsx415.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
>> From: H. Peter Anvin [mailto:hpa@zytor.com]
>> The "EFI boot" patchset looks fairly unobtrusive to me.  One objection:
>> the VIDEO_TYPE_ numbers appear split up into groups; and the EFI one
>> probably should be 0x70 instead of 0x24.
> 
> Should I change this and resend the patchset? Or you modify it before
> merging?
> 

I'd be easier if you could change and resend.

	-hpa
