Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbXCEKfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbXCEKfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933051AbXCEKfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:35:42 -0500
Received: from il.qumranet.com ([82.166.9.18]:33979 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933054AbXCEKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:35:41 -0500
Message-ID: <45EBF1E3.4030003@qumranet.com>
Date: Mon, 05 Mar 2007 12:33:07 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>
Subject: Re: [patch] KVM: T60 resume fix
References: <20070302072100.GB30634@elte.hu> <20070302080441.GA12785@elte.hu> <20070302102018.GA11549@elte.hu> <20070302102216.GA13575@elte.hu> <45E93012.4000100@qumranet.com> <20070305082251.GA23366@elte.hu> <45EBD9BC.4030801@qumranet.com> <20070305084449.GA1706@elte.hu> <20070305085718.GA2513@elte.hu> <45EBE288.8010101@qumranet.com> <20070305100537.GA9175@elte.hu>
In-Reply-To: <20070305100537.GA9175@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>>> suspend/resume works fine now and there are no warning messages 
>>> whatsoever (with suspend simulation). Thanks Avi!
>>>       
>> Where do I find this suspend simulation?  Sounds like a great suspend 
>> debugging tool.
>>     
>
> it's just the simple hack below.
>
>
>   

Thanks, I'll put it to good use.  Are you planning to upstream it?  Not 
for 2.6.21, presumably ;)



-- 
error compiling committee.c: too many arguments to function

