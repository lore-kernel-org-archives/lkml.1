Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbYKQNBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbYKQNBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYKQNBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:01:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61811 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbYKQNBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:01:09 -0500
Message-ID: <49216A44.4070203@cn.fujitsu.com>
Date: Mon, 17 Nov 2008 20:57:40 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: paulmck@linux.vnet.ibm.com, Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
 V2
References: <4917A8E7.8060801@cn.fujitsu.com> <20081110184520.GC6685@linux.vnet.ibm.com> <4918D7E4.9030107@cn.fujitsu.com> <20081111010331.GF6685@linux.vnet.ibm.com> <491B9581.2080201@cn.fujitsu.com> <20081113173114.GA6788@linux.vnet.ibm.com> <491CCE58.1040701@cn.fujitsu.com> <20081114021152.GF6788@linux.vnet.ibm.com> <491D2B16.8060000@cn.fujitsu.com> <20081114122543.0578bd5e@bike.lwn.net> <20081115203942.GA7108@linux.vnet.ibm.com>
In-Reply-To: <20081115203942.GA7108@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo,

Is there any problem for this document added to kernel?

Thanx, Lai.

Paul E. McKenney wrote:
> On Fri, Nov 14, 2008 at 12:25:43PM -0700, Jonathan Corbet wrote:
>> On Fri, 14 Nov 2008 15:39:02 +0800
>> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>>
>>> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>>
>>> Paul E. McKenney wrote:
>> All seems good.  To answer Paul's original question:
>>
>>> If so, please see attached patch and let me know what you think.
>>> Being too lazy to convert the cartoon to ASCII graphics, I simply
>>> left a URL to the .jpg on the LWN website.  Thus we need an ack/nack
>>> from Jon Corbet (CCed).
>> Of course I have no problem with the LWN links; they will remain stable.
>>
>> If nobody objects, I'll drop this into my documentation tree.  Gotta
>> have *something* there, after all, or it might start to feel
>> neglected...
> 
> Works for me!
> 
> 							Thanx, Paul
> 
> 
> 


