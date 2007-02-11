Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbXBKGLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbXBKGLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 01:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXBKGLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 01:11:51 -0500
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:4201 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093AbXBKGLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 01:11:50 -0500
Message-ID: <45CEB39F.4070700@qumranet.com>
Date: Sun, 11 Feb 2007 08:11:43 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: caglar@pardus.org.tr, lkml <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       stable@kernel.org
Subject: Re: + kvm-fix-asm-constraint-for-lldt-instruction.patch added to
 -mm tree
References: <200701310036.l0V0abnE002548@shell0.pdx.osdl.net>	<200702101932.30623.caglar@pardus.org.tr> <20070210130606.393ed586.akpm@linux-foundation.org>
In-Reply-To: <20070210130606.393ed586.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Feb 2007 06:11:49.0815 (UTC) FILETIME=[844F5C70:01C74DA3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 10 Feb 2007 19:32:30 +0200 "S.Çağlar Onur" <caglar@pardus.org.tr> wrote:
>
>   
>> Hi;
>>
>> 31 Oca 2007 Çar tarihinde, akpm@osdl.org şunları yazmıştı: 
>>     
>>> The patch titled
>>>      kvm: Fix asm constraint for lldt instruction
>>>  has been added to the -mmtree.  Its filename is
>>>      kvm-fix-asm-constraint-for-lldt-instruction.patch
>>>       
>> Is it possible to merge it into .20.1, its really trivial and its the only 
>> compile fix for gcc-4.2.x?
>>
>>     
>
> OK by be.  Avi?
>   

No objections, though I'm wondering whether fixing a miscompile on an 
unreleased compiler is a stability fix.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

