Return-Path: <linux-kernel-owner+w=401wt.eu-S1031324AbXDZQOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031324AbXDZQOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031325AbXDZQOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:14:44 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:58062 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031324AbXDZQOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:14:43 -0400
Message-ID: <4630CFE6.1050702@nortel.com>
Date: Thu, 26 Apr 2007 10:14:30 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg> <20070426103051.GP17387@elf.ucw.cz> <20070426104052.GA19072@elf.ucw.cz> <1177585897.6814.49.camel@johannes.berg> <20070426111645.GR17387@elf.ucw.cz> <1177586850.6814.52.camel@johannes.berg> <20070426112641.GS17387@elf.ucw.cz> <1177587308.6814.57.camel@johannes.berg>
In-Reply-To: <1177587308.6814.57.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Apr 2007 16:14:35.0435 (UTC) FILETIME=[FB4487B0:01C7881D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:

> Judging from experience with the wext 32/64 bit fiasco it seems to be
> rather uncommon to use 32-bit userspace on 64-bit machines.

I disagree...it's quite common.  I think its the standard way of doing 
things for ppc64, for instance.

Chris
