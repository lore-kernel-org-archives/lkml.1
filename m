Return-Path: <linux-kernel-owner+w=401wt.eu-S1760786AbYARBUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786AbYARBUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYARBTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:19:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39306 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbYARBTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:19:52 -0500
Message-ID: <478FFD60.8030303@zytor.com>
Date: Thu, 17 Jan 2008 20:14:08 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Use v8086_mode helper, trivial unification
References: <1200611078.5724.46.camel@brick>  <478FDE76.3070309@zytor.com>	 <1200612389.5724.63.camel@brick>  <478FF9F3.9030604@zytor.com> <1200618869.5724.83.camel@brick>
In-Reply-To: <1200618869.5724.83.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> 
>>> /* still need a define here, as one is long and one is unsigned long.
>>>  * but this is another target for unification I guess. */
>>> #define regs_return_value(regs) ((regs)->ax)
>> Indeed...
> 
> I think this comes out of Roland's patches unifying some names eip/rip,
> eax/rax, etc.
> 
> CC'd in case he felt like more work ;-)
> 

Funny, I thought those were mine :-/

	-hpa
