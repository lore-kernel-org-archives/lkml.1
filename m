Return-Path: <linux-kernel-owner+w=401wt.eu-S1761660AbZCXPmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761660AbZCXPmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760726AbZCXPmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:42:33 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:59748 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569AbZCXPmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:42:33 -0400
Message-ID: <49C8FF61.906@monstr.eu>
Date: Tue, 24 Mar 2009 16:42:25 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: John Linn <John.Linn@xilinx.com>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       microblaze-uclinux@itee.uq.edu.au
Subject: Re: Microblaze linux support
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <49C8FBB5.5010107@monstr.eu> <20090324153314.C8BD144806B@mail135-wa4.bigfish.com>
In-Reply-To: <20090324153314.C8BD144806B@mail135-wa4.bigfish.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Linn wrote:
>> Hi all,
>>> Hi all,
>>>
>>> I think that is the right time to send you next pack with
>>> Microblaze support. It is seventh pack - some previous packs
>>> was review by community and I hope there are not any big faults.
>>>
>>> We tested this kernel on some boards.
>>> We have GIT server up and gitweb is available at
> http://developer.petalogix.com/git/gitweb.cgi
>>> All information about git clone you can find on gitweb.
>>> This pack is available in for-linus branch. Information about other
> branches are on gitweb too.
>>> More information about microblaze fdt kernel you can find at
> www.monstr.eu/fdt/
>>> If you want to test kernel with microblaze toolchain let me know.
>>>
>>> I added only uart16550 and uartlite support - that's enought for
> first merge.
>>>
>>> Thanks for you comments and especially for your ACK,
>>> Michal
>>>
>> It is a week ago when I sent v7 pack to LKML for reviewing.
>>
>> I have got ACK from John Williams who is the best person from
> microblaze
>> linux community.
>> I got ACK from Randy Dunlap for Kconfig and Makefile patches.
>> Thomas Gleixner reviewed IRQ and Timer code.
>> Ingo Molnar confirms me that all coding style violation (checking with
>> checkpatch.pl) are false positive.
>>
>> John L: Could you give me ACK from Xilinx?
> 
> Acked-by: John Linn <john.linn@xilinx.com>
> 
> Thanks for all your work to move this forward.

Thanks too.

Michal

> 
> -- John
> 
>> Thanks,
>> Michal
>>

