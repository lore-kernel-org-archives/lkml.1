Return-Path: <linux-kernel-owner+w=401wt.eu-S934676AbXGMFwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934676AbXGMFwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 01:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXGMFwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 01:52:05 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35095 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbXGMFwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 01:52:03 -0400
To: Adrian Bunk <bunk@stusta.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] re-add required code to include/asm-v850/unistd.h
References: <20070707211124.GN3492@stusta.de>
	<200707072341.16389.arnd@arndb.de> <20070711151608.GG3492@stusta.de>
From: Miles Bader <miles.bader@necel.com>
Reply-To: Miles Bader <miles@gnu.org>
System-Type: i686-pc-linux-gnu
Blat: Foop
Date: Fri, 13 Jul 2007 14:49:31 +0900
In-Reply-To: <20070711151608.GG3492@stusta.de> (Adrian Bunk's message of "Wed\, 11 Jul 2007 17\:16\:08 +0200")
Message-Id: <buo7ip4vono.fsf@dhapc248.dev.necel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:
>> Wouldn't it be more appropriate to just open-code the contents of these
>> macros in the place where they are used?
>> 
>> Even better probably would be to convert the v850 kernel_thread code
>> to call do_fork directly, like most other architectures do.
>
> The bigger problem seems to be that v850 is not that near at compiling 
> at all...  :-(

Yeah, I'm working on other things these days, so I only check up on the
v850 port occasionally.

I'll see what I can do to get things working again.

Thanks,

-Miles

-- 
"Most attacks seem to take place at night, during a rainstorm, uphill,
 where four map sheets join."   -- Anon. British Officer in WW I
