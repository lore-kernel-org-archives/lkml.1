Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab0CNXmO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 19:42:14 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:54242 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab0CNXmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 19:42:10 -0400
Message-ID: <4B9D744A.5080301@necel.com>
Date: Mon, 15 Mar 2010 08:42:02 +0900
From: Shinya Kuribayashi <shinya.kuribayashi@necel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: wuzhangjin@gmail.com
CC: Ralf Baechle <ralf@linux-mips.org>, Greg KH <gregkh@suse.de>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Loongson-2F: Flush the branch target history such
 as BTB and RAS
References: <cover.1268153722.git.wuzhangjin@gmail.com>         <d513f16856e499e82f0b4e428c97fe06afb5a426.1268153722.git.wuzhangjin@gmail.com>         <4B98632E.70806@necel.com>  <20100311095944.GC18065@linux-mips.org> <1268452341.21443.3.camel@falcon>
In-Reply-To: <1268452341.21443.3.camel@falcon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin wrote:
> On Thu, 2010-03-11 at 10:59 +0100, Ralf Baechle wrote:
>> On Thu, Mar 11, 2010 at 12:27:42PM +0900, Shinya Kuribayashi wrote:
>>
>>> Are you sure that RAS represents "Row Address Strobe", not "Return
>>> Address Stack?"
> 
> This should be Return Address Stack.
> 
> Will resend this patch later.

Thanks for the head's up.
-- 
Shinya Kuribayashi
NEC Electronics
