Return-Path: <linux-kernel-owner+w=401wt.eu-S1761696AbZEAQdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761696AbZEAQdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbZEAQd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:33:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42523 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbZEAQdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:33:25 -0400
Message-ID: <49FB23E4.2030900@zytor.com>
Date: Fri, 01 May 2009 09:31:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/11] section name cleanup for x86
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu> <20090501115849.GB24706@elte.hu> <20090501120757.GA23672@uranus.ravnborg.org>
In-Reply-To: <20090501120757.GA23672@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Fri, May 01, 2009 at 01:58:49PM +0200, Ingo Molnar wrote:
>> * Tim Abbott <tabbott@MIT.EDU> wrote:
>>
>>> This patch series cleans up the section names on the x86
>>> architecture.  It requires the architecture-independent macro
>>> definitions from this patch series:
>>>
>>> <http://www.spinics.net/lists/mips/msg33499.html>
>> Hm, we cannot pick the x86 bits up into the x86 tree without having 
>> these macros upstream first. So those macros need acks from Sam and 
>> maybe Linus will take them out of order. (they are pure additions so 
>> they look fairly safe and uncontroversial)
> 
> Thats the plan.
> 

By the way, I personally like the overall approach; I haven't studied
the patchset in detail yet, though.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

