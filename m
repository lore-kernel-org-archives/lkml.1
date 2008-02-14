Return-Path: <linux-kernel-owner+w=401wt.eu-S932236AbYBNXUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbYBNXUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbYBNXUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:20:34 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35848 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbYBNXUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:20:32 -0500
Message-ID: <47B4CCBC.6050208@davidnewall.com>
Date: Fri, 15 Feb 2008 09:50:28 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Bill Davidsen <davidsen@tmr.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Subject: Re: Feature Removals for 2.6.25
References: <1201829922.23523.68.camel@brick>	<47B3AC24.5050605@tmr.com> <20080213185502.0005dd4d@extreme> <47B48564.1010709@tmr.com> <47B4876B.6020100@linux.intel.com>
In-Reply-To: <47B4876B.6020100@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Bill Davidsen wrote:
>> Note that because the hardware is old, it's highly likely that most
>> of it will be retired before that sk98lin driver needs a change. I
>> can't see anyone using sk98lin on a new system, so it would be less
>> contentious to let the hardware (or users) die of natural causes if
>> you can.
>>
>
> the problem is that the new one DOES NOT GET FIXED.
> THAT is a huge problem; it means we have a buggy driver...

If the old one works and the new one is buggy, it begs the question of
why anybody bothered writing a new one in the first place.  "If it ain't
broke, don't fix it," might have been good advice to follow.
