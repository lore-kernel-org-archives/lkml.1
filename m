Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbXECTDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbXECTDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbXECTDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:03:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:21211 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbXECTDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:03:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=jMdrs7VN4DlfKIpA4Qu4CbfggI3D/eovvAaGuFEa8wrU2t2FplxoIzr8HhYBC3yZ0Yc31KpuDcAsx8baSlwL1QccUtiMxCCsOZWk/ZyA4IFIn1YNX4ynQRlekgJcS5H3JRzFS3X8kJRNl/3q+XM1bPDZUj/6NEPIUrWA++NKGsg=
Message-ID: <463A31EE.20907@gmail.com>
Date: Thu, 03 May 2007 23:03:10 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org,
       Johannes Stezenbach <js@linuxtv.org>
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points about ...)
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>	 <46389278.1070208@gmail.com> <20070502155125.280320@gmx.net>	 <4638C046.1020005@gmail.com> <20070503112013.272380@gmx.net>	 <4639F554.1040505@gmail.com> <20070503153129.268110@gmx.net>	 <463A0462.5070106@gmail.com>	 <d9def9db0705030859y66b1ef8fv22fc844c77bcc3c6@mail.gmail.com>	 <463A0B36.5080204@gmail.com>	 <d9def9db0705031019l5083d1c1h607b0829ab526f1@mail.gmail.com> <1178215045.12651.124.camel@localhost>
In-Reply-To: <1178215045.12651.124.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> Enough. Let's stop arguing non technical issues.
> 
> If either one of you have any technical argue against the Trent's
> patches, please point where the fix is wrong. Otherwise, if you wish,
> you may send an acked-by agreeing with the fix.
> 

Why don't you stop this childish behaviour ?

After explaining to you the reasons in the previous mail:
being the author and maintainer of dst/dst_ca and maintainer of
dvb-bt8xx, i NACK this change

(1) You aren't DVB maintainer
(2) one shouldn't make such judgement calls on somebody else's driver
unless it falls within your own maintainership


> Mauro.
> 
> Em Qui, 2007-05-03 às 19:19 +0200, Markus Rechberger escreveu:
>> On 5/3/07, Manu Abraham <abraham.manu@gmail.com> wrote:
>>> Markus Rechberger wrote:
>>>
>>>> Manu,
>>>>
>>>> to me it looks like your  attitude is not acceptable here, I sent
>>>> several mails already which you just use to ignore.
>>> You very well know the reason why i am ignoring your mails. You just
>>> tend to flame people for nothing. I tend to ignore the flamers.
>>>
>> You should stop to rely on the history, since such a flame needs at
>> least 2 parties and back then you were also involved. There's nothing
>> else to say about that.
>>
>>>> If you don't change that attitude immediatelly I'd really wish to get
>>>> you banned of this community until you're open for discussions.
>>>>
>>>> http://www.mail-archive.com/linux-dvb%40linuxtv.org/msg22943.html
>>>>
>>>> there's a bugreport and you fully ignore it, and you blame it on the
>>>> "politicians" here, telling me that there are mails out there
>>>> somewhere shows that you're not interested in getting forward.
>>>>
>>> That bug report very well proves my point.
>> Well it would be nice if you could answer the question in that mail
>> then, I don't see any reason why you shouldn't answer it.
>>
>> It's just a guess, but it seems like that you had a problem with other
>> developers at that part and it seems like it didn't get to an end
>> (probably because both parties didn't agree with each other)
>>
>> Markus
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

