Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbXJYSGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbXJYSGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXJYSF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:05:56 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52259 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbXJYSF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:05:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic runtime service support
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	<alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
	<m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>
	<20071025095639.22f6cad0@laptopd505.fenrus.org>
	<4720CCBC.1050700@zytor.com>
	<m1y7dr3xha.fsf@ebiederm.dsl.xmission.com>
	<4720D797.1020903@zytor.com>
Date: Thu, 25 Oct 2007 12:04:15 -0600
In-Reply-To: <4720D797.1020903@zytor.com> (H. Peter Anvin's message of "Thu,
	25 Oct 2007 10:51:19 -0700")
Message-ID: <m1tzof3wbk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>>>
>>> Well, the original motivation for all of this was to enable implementation of
> a
>>> EFI framebuffer (UGA/GOP).  Now, you can say what you want about EFI (and I
>>> definitely have my opinion on it), but that seems legitimate to me.
>>
>> To be very clear.  I think we need the EFI boot parameters but
>> we certainly don't runtime services to implement an EFI framebuffer.
>>
>
> Ying claimed that GOP requires EFI runtime services.  Is that not true?

None of the EFI framebuffer patches that I saw used EFI runtime services.

Eric
