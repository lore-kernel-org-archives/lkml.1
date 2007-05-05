Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbXEESqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbXEESqp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbXEESqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:46:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:22366 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbXEESqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=OLCAuhbUdR4HD+OkNHQROqgL+xs1ly/l9kMyg7ML/LN7UESQ1/xKm4mlyiozhx9FWbNHVucmGh7SSthJHulD7g163Pw4lGlHVDUKuODADiFXs8HrOAvCO9GfA+8VB7OQFNav/xxBfYSxCr1aGXTFgdZAHHi/a1p0qOnyufy/9cs=
Message-ID: <463CD106.3000706@gmail.com>
Date: Sat, 05 May 2007 22:46:30 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org,
       Johannes Stezenbach <js@linuxtv.org>
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points about ...)
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>	 <46389278.1070208@gmail.com> <20070502155125.280320@gmx.net>	 <4638C046.1020005@gmail.com> <20070503112013.272380@gmx.net>	 <4639F554.1040505@gmail.com> <20070503153129.268110@gmx.net>	 <463A0462.5070106@gmail.com>	 <d9def9db0705030859y66b1ef8fv22fc844c77bcc3c6@mail.gmail.com>	 <463A0B36.5080204@gmail.com>	 <d9def9db0705031019l5083d1c1h607b0829ab526f1@mail.gmail.com>	 <1178215045.12651.124.camel@localhost>  <463A31EE.20907@gmail.com> <1178388401.12541.115.camel@localhost>
In-Reply-To: <1178388401.12541.115.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mauro,

Mauro Carvalho Chehab wrote:
> Hi Manu,
> 
> Em Qui, 2007-05-03 às 23:03 +0400, Manu Abraham escreveu:
>> Mauro Carvalho Chehab wrote:
>>> Enough. Let's stop arguing non technical issues.
>>>
>>> If either one of you have any technical argue against the Trent's
>>> patches, please point where the fix is wrong. Otherwise, if you wish,
>>> you may send an acked-by agreeing with the fix.
>>>
>> Why don't you stop this childish behaviour ?
> 
> I just want to solve the current issue, and decide the proper way for Trent's fixes. 
> 
> I consider you a very skilled programmer. Unfortunately, it seems that
> you're not interested anymore on submitting kernel patches, since your
> last contribution, as an author, were back on Aug, 8, 2006:

hmm .. multiple Caps "I 's" ..  anyway.

>From my side, quite some time has been put forward to write that mail.
Inspite of that if you feel that you do have to go your own way, then it
is completely upto you. I would say: do as you feel in such a case.

In such a case are you willing to fix all the issues/requests that surface ?

Really do you want me to explain those issues in this thread ? I would
say, think over it yourself, why that huge gap occurred. Take some time
off all this, think on a cool mind.


> 
>         commit bbdd11fa957913d6648cabbca59be1da479180ed
>         Author: Manu Abraham <abraham.manu@gmail.com>
>         Date:   Tue Aug 8 15:48:08 2006 -0300
> 
>             V4L/DVB (4432): Fix Circular dependencies
> 
>             Signed-off-by: Manu Abraham <manu@linuxtv.org>
>             Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org> 
> 
> It would be a pleasure to have you contributing again. However, we need to fix the pointed issues.


I do have a written another mail with regards to the issues that do
prevail on the "discussions thread"


> 
> Also, considering that:
> 
> 1) the Trent patches addressing the issues exists since august, 2006;
> 
> 2) nobody pointed any troubles at the current approach;
> 

Surely there was a long mail from my side. I don't know whether you
missed that mail, but surely you should read it again.


> 3) the patch does provide a proper fix for module removal, working well on both hardwares with and without DST;
>

Other than what i wrote earlier:

DST is not for just one device alone (It is really a combo driver),
AFAICS there are ~15 -20 main devices, for which there are additional 5
- 6 clone manufacturers. So eventually there are around 80 different
cards at least.

So, in fact there are a large number of cards that do exist rather than
the one card that i have sent you, some time back.

The non dst cards supported by dvb-bt8xx are just 3 or 4 cards, IIRC.


> 4) I'm responsible for reviewing and forwarding patches for /drivers/media stuff;
> 
> I think there's no reason for me to not forward the proper fixes to mainstream.
> 

>From what i know, you do need an ACK from the relevant maintainer too.
Did the concept of dvb-maintainers change without any of the DVB
developers knowing ?
