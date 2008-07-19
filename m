Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbYGSEr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbYGSEr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 00:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYGSErS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 00:47:18 -0400
Received: from mail.lang.hm ([64.81.33.126]:33797 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbYGSErR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 00:47:17 -0400
Date: Fri, 18 Jul 2008 21:45:29 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: "Rodrigo Rubira Branco (BSDaemon)" <rbranco@la.checkpoint.com>
cc: Willy Tarreau <w@1wt.eu>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
       "'Justin Forbes'" <jmforbes@linuxtx.org>,
       "'Zwane Mwaikambo'" <zwane@arm.linux.org.uk>,
       "'Theodore Ts'o'" <tytso@mit.edu>,
       "'Randy Dunlap'" <rdunlap@xenotime.net>,
       "'Dave Jones'" <davej@redhat.com>,
       "'Chuck Wolber'" <chuckw@quantumlinux.com>,
       "'Chris Wedgwood'" <reviews@ml.cw.f00f.org>,
       "'Michael Krufky'" <mkrufky@linuxtv.org>,
       "'Chuck Ebbert'" <cebbert@redhat.com>,
       "'Domenico Andreoli'" <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "'Alan Cox'" <alan@redhat.com>, caglar@pardus.org.tr,
       casey@schaufler-ca.com, spender@grsecurity.net, pageexec@freemail.hu,
       rodrigo@kernelhacking.com
Subject: Re: [stable] Linux 2.6.25.10 (resume)
In-Reply-To: <4880B6F7.90109@la.checkpoint.com>
Message-ID: <alpine.DEB.1.10.0807182139540.6370@asgard>
References: <20080701151057.930340322@mini.kroah.org> <200807021257.47593.caglar@pardus.org.tr> <20080702144149.GA16850@suse.de> <200807021809.07679.caglar@pardus.org.tr> <005001c8e6f8$ac0955f0$a6181fac@ad.checkpoint.com> <20080716044905.GA9033@suse.de>
 <4880A3B1.3050103@la.checkpoint.com> <20080718152028.GA5995@1wt.eu> <4880B6F7.90109@la.checkpoint.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008, Rodrigo Rubira Branco (BSDaemon) wrote:

> Willy Tarreau escreveu:
>> On Fri, Jul 18, 2008 at 11:07:45AM -0300, Rodrigo Rubira Branco (BSDaemon) 
>> wrote:
>> 
>>>> getting very annoyed at people saying I am somehow doing the job I do
>>>> for free, on my own time, incorrectly,
>>>> 
>>>> greg k-h
>>>> 
>>> For free? Hum, let's forget that you work as a linux developer... we are
>>> also trying to contribute in some way for free...
>>> 
>> 
>> Rodrigo, this type of personal comment is unjustified and very 
>> inappropriate
>> IMHO. It's not fair at all to judge people's personal involvement based on
>> whom they work for. If you'd work at nights and week-ends after your job to
>> backport bugfixes, you'd know what I'm talking about. BTW, one day you may
>> notice that the most personally involved ones *finally* get a job at a 
>> Linux
>> vendor's, and not the reverse.
>> 
>> So please take care of not dismissing what people do on their own time, and
>> try be kind enough to bring problems to them directly if any.
>> 
>> Thanks,
>> Willy
>>
>> 
>
> Hey Willy,
>
> Sorry, but my comment was not unjustified, since he started saying he is 
> doing a free-job and we are saying is doing it  'wrong'.... That's not the 
> case.  We all are doing a free job, contributing in some way, not just you, 
> him or me... Everybody involved in this discussion. 
> But he, more than others, are also paid to do that job...

he's paied to work on what his company chooses to have him do for Linux. 
Greg is saying that he is doing all the -stable work on his own time, 
after finishing the work on Linux that his employer chooses to pay him 
for.

> Also, as a 
> developer of any project so important as linux, doing that for free or not, 
> you have a responsibility.
> You can choose to take it or not (I think that's why there is not many 
> people with balls to accept it, and I congrats Greg for that).

if you would define the job up front and ask for someone to take it on you 
could then argue that they aren't doing it right. but when someone 
volunteers to do something and creates the job, claiming that they re 
doing it 'wrong' after the fact is insulting. the job is what he defined 
it to be when he created it. if you want to define the job differently you 
are welcome to do just that and start doing the different job (or hire 
someone to do the job). if you are right then Greg's work will be 
irrelavent and he can stop wasting his time. but unless you are willing to 
step up you should not take the tone that you have taken. you can ask for 
changes, explain why you think they are better, try and convince others, 
but you cannot say that he must or that he has a responsibility to do it 
your way.

David Lang

> Just to finish my statement, let's stop this 'forks' on the main thread, 
> please.  I'm not here to judge anybody. Since it's an open project, we are 
> trying to give our contribution as security researchers and as people who 
> understand the security marketing.
>
>
> P.S.:  Blahblahblah, disclaimer that this is my opinion and not the opinion 
> of the company that I work for.
>
>
> Regards,
>
>
> Rodrigo (BSDaemon).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
