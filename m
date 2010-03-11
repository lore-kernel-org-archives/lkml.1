Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab0CKUPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:15:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:32858 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758120Ab0CKUO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:14:59 -0500
Message-ID: <4B994EC4.2050705@kernel.org>
Date: Thu, 11 Mar 2010 12:12:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.com
Subject: Re: mmotm boot panic bootmem-avoid-dma32-zone-by-default.patch
References: <49b004811003041321g2567bac8yb73235be32a27e7c@mail.gmail.com> <20100305032106.GA12065@cmpxchg.org> <4B90C921.6060908@kernel.org> <4B90DC3C.1060000@gmail.com> <4B92FE9E.90600@kernel.org> <4B98CBC8.6080008@gmail.com>
In-Reply-To: <4B98CBC8.6080008@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 02:54 AM, Jiri Slaby wrote:
> On 03/07/2010 02:17 AM, Yinghai Lu wrote:
>> On 03/05/2010 02:26 AM, Jiri Slaby wrote:
>>> On 03/05/2010 10:04 AM, Yinghai Lu wrote:
>>>> according to context
>>>> http://patchwork.kernel.org/patch/73893/
>>>>
>>>> Jiri,
>>>> please check current linus tree still have problem about mem_map is
>>>> using that much low mem?
>>>
>>> Hi!
>>>
>>> Sorry, I don't have direct access to the machine. I might try to ask the
>>> owners to do so.
>>>
>>>> on my 1024g system first node has 128G ram, [2g, 4g) are mmio range.
>>>
>>> So where gets your mem_map allocated (I suppose you're running flat
>>> model)?
>>
>> what kernel version? 2.6.27?
> 
> Hi, yes, it is 2.6.27.

SLES 11?

Yinghai
