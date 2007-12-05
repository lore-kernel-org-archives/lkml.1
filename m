Return-Path: <linux-kernel-owner+w=401wt.eu-S1752396AbXLEJ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbXLEJ1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 04:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbXLEJ1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 04:27:08 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:49195 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbXLEJ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 04:27:07 -0500
Message-ID: <47566EE0.2090709@cateee.net>
Date: Wed, 05 Dec 2007 10:26:56 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9246] On 2.6.24-rc1-gc9927c2b BUG: unable to handle kernel
 paging request at virtual address 3d15b925
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071204100832.GA11031@elte.hu> <475584A4.6080800@cateee.net> <200712042108.15262.rjw@sisk.pl>
In-Reply-To: <200712042108.15262.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, 4 of December 2007, Giacomo A. Catenazzi wrote:
>> Ingo Molnar wrote:
>>> hi,
>>>
>>> * Giacomo Catenazzi <cate@cateee.net> wrote:
>>>
>>>> On 2.6.24-rc1-gc9927c2b BUG: unable to handle kernel paging request at 
>>>> virtual address 3d15b925
>>>>
>>>> In last git, I see the following BUGs in various programs.  It seems 
>>>> reproducible, but sometime I've hard lookup on poweroff.
>>> do you still get this with more recent kernels? We had a number of fixes 
>>> for memory corruptors since -rc1 - perhaps one of them took care of your 
>>> problem as well.
>> No, the problem was solved few days after the report.
> 
> Can you point me to the fix, please?

Unfortunately no. To much chaos in that period:
I think I incurred into two or three different kernel bugs
(and a Debian keyboard bug) in one or two days. Usually
I find such important bugs only few times per year,
and never together).

I tried also git-bisect, but too much runs, to many non-compiling
commits, bad environment (the Debian bug) and the quick fix of the
kernel bug ;-) stopped me in further searching.

ciao
	cate
