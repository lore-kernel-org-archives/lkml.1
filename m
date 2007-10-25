Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbXJYRzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbXJYRzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbXJYRzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:55:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49306 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbXJYRzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:55:39 -0400
Message-ID: <4720D797.1020903@zytor.com>
Date: Thu, 25 Oct 2007 10:51:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
 runtime service support
References: <1193295473.23935.202.camel@caritas-dev.intel.com>	<alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>	<m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>	<20071025095639.22f6cad0@laptopd505.fenrus.org>	<4720CCBC.1050700@zytor.com> <m1y7dr3xha.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1y7dr3xha.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>>
>> Well, the original motivation for all of this was to enable implementation of a
>> EFI framebuffer (UGA/GOP).  Now, you can say what you want about EFI (and I
>> definitely have my opinion on it), but that seems legitimate to me.
> 
> To be very clear.  I think we need the EFI boot parameters but
> we certainly don't runtime services to implement an EFI framebuffer.
> 

Ying claimed that GOP requires EFI runtime services.  Is that not true?

	-hpa
