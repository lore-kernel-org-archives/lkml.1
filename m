Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYIQSTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYIQSTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYIQSTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:19:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYIQSTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:19:15 -0400
Message-ID: <48D149CA.1000000@zytor.com>
Date: Wed, 17 Sep 2008 11:17:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v5
References: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com>	 <20080917073058.GA3770@x200.localdomain>	 <20080917084754.GC24035@elte.hu> <48D13960.2020902@zytor.com> <86802c440809171110y3b91e27q382c6ee7bcd58c28@mail.gmail.com>
In-Reply-To: <86802c440809171110y3b91e27q382c6ee7bcd58c28@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>>
>> It's probably worth pointing out that we had similar transition pains when
>> we introduced the loglevel tags.  If you used an old dmesg/klogd you got the
>> loglevel tags; we cleaned them up.
> 
> want to expand loglevel tags to two digi bits, hope the dmesg/klogd
> could handle it.
> 

I doubt they'd be written to handle that already.

	-hpa
