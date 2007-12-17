Return-Path: <linux-kernel-owner+w=401wt.eu-S933252AbXLQAHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbXLQAHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 19:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761994AbXLQAH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 19:07:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41644 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761976AbXLQAHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 19:07:25 -0500
Message-ID: <4765BD91.9080909@zytor.com>
Date: Sun, 16 Dec 2007 16:06:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] x86: Final unification of local_{32|64}.h
References: <1197806669.3749.44.camel@brick> <20071216153158.GA891@elte.hu>	 <4765AB32.9040608@zytor.com> <1197848331.3749.86.camel@brick>	 <4765B930.8010208@zytor.com> <1197849591.3749.88.camel@brick>
In-Reply-To: <1197849591.3749.88.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
>>
>> #define _ASM_INC " incl "
>>
>> 	_ASM_INC "%0"
> 
> Not sure if you were just tossing a space on the end of my example,
> but do you also put a leading space on the " incl " in addition to
> the trailing space?
> 

That is what I have, again, just to make mistakes harder.

	-hpa
