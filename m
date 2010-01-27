Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671Ab0A0Q2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0A0Q2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436Ab0A0Q2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:28:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53457 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab0A0Q2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:28:31 -0500
Message-ID: <4B606920.8000306@zytor.com>
Date: Wed, 27 Jan 2010 08:26:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Dean Nelson <dnelson@redhat.com>,
       Russ Anderson <rja@sgi.com>, ozan@pardus.org.tr,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
       Gene Heskett <gene.heskett@verizon.net>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Mark Hounschell <markh@compro.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       David Rientjes <rientjes@google.com>,
       Haicheng Li <haicheng.li@linux.intel.com>
Subject: Re: [GIT PULL] x86 fixes for 2.6.33-rc6
References: <201001270833.o0R8X7ZN018729@terminus.zytor.com> <alpine.LFD.2.00.1001270249190.24253@localhost.localdomain> <20100127112446.GA19613@elte.hu>
In-Reply-To: <20100127112446.GA19613@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 03:24 AM, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Wed, 27 Jan 2010, H. Peter Anvin wrote:
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/x86/linux-2.6-tip.git x86-fixes-for-linus
>>
>> That doesn't work for me at all.
> 
> i think Peter typoed it and the git/ portion went missing, it should have 
> been:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git x86-fixes-for-linus
> 
>> I assume you meant
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
>>
>> (note the "git/tip" instead of "x86")
> 
> Yes, that works too. The x86 repo is symlinked to the tip repo.
> 

Sorry about that.  Get it done before bed syndrome.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

