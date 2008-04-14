Return-Path: <linux-kernel-owner+w=401wt.eu-S1758464AbYDNATo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbYDNATo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYDNATG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:19:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35605 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbYDNATE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:19:04 -0400
Message-ID: <4802A155.8000006@zytor.com>
Date: Sun, 13 Apr 2008 17:12:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86 git tree broken (bisected)
References: <200804102159.14563.rjw@sisk.pl> <200804140141.45830.rjw@sisk.pl> <48029B04.9010108@zytor.com> <200804140209.28755.rjw@sisk.pl>
In-Reply-To: <200804140209.28755.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 14 of April 2008, H. Peter Anvin wrote:
>> Rafael J. Wysocki wrote:
>>> Well, unfortunately current x86.git doesn't even boot on the affected box.
>>> It 'cannot open root device "md1" or unknown-block (0,0)' (Ingo, any ideas?).
>>>
>>> Today I have to take some sleep, so I'll try to debug it tomorrow, unless
>>> someone else does it earlier.
>>>
>> Sounds like you didn't compile in the appropriate RAID support...
> 
> In fact I did, but I didn't notice that the initrd image was not built
> correctly due to a local error.
> 

Happens :)

	-hpa

