Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbXD3PNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbXD3PNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423329AbXD3PNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:13:30 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:38060 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755378AbXD3PN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:13:29 -0400
Message-ID: <4636058B.3070603@aitel.hist.no>
Date: Mon, 30 Apr 2007 17:04:43 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Uwe Bugla <uwe.bugla@gmx.de>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, mchehab@infradead.org
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and	pseudo-authorities
References: <20070429182209.267430@gmx.net>	 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>	 <20070429205925.129920@gmx.net>	 <alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>	 <20070429230037.95120@gmx.net> <1177894713.3046.5.camel@pc06.localdom.local> <20070430110255.267000@gmx.net> <4635D139.4030609@aitel.hist.no> <20070430115000.194060@gmx.net>
In-Reply-To: <20070430115000.194060@gmx.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Bugla wrote:
> -------- Original-Nachricht --------
> Datum: Mon, 30 Apr 2007 13:21:29 +0200
> Von: Helge Hafting <helge.hafting@aitel.hist.no>
> An: Uwe Bugla <uwe.bugla@gmx.de>
> CC: linux-kernel@vger.kernel.org
> Betreff: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and	pseudo-authorities
>
>   
>> Uwe Bugla wrote:
>>     
>>> In this ten Emails you will yourself see the intellectual and technical
>>>       
>> proof in how far Mr. Chehab is acting with nothing else but:
>>     
>>> a. Lies
>>> b. Unproven thesis
>>> c. Stigmatizations
>>>
>>> and so on.
>>>
>>> THIS MAN HAS NO IDEA, BUT HE HAS THE POWER!
>>>   
>>>       
>> Please note that there are ways to replace a bad maintainer. 
>> We still try to keep it polite.
>>
>> But note that you can't have someone "fired", no matter how bad they
>> do their job.  A bad maintainer is usually better than none - the bad
>> maintainer might improve. Or at least get some simple stuff done.
>>
>> You therefore replace a bad maintainer by taking over the position. 
>> Contact whoever is above the maintainer (Linus or some other
>> higher-level maintainer). You explain the problem, and you must also
>> show that you have the time and knowledge to do a better job. 
>>     
>
> Hi Helge,
> A. I do neither have enough skills to take up a maintainers role
>   
Then your only hope is to find someone else that is interested.
> B. Linus and Andrew are high-leveled informed about the whole structural problem, but they close their eyes, they simply do not want to see the necessity of a replacement.
> That is at least my impression. 
>   
The aren't doing any less than you do. They don't provide a better
maintainer, but neither do you.   Linus and  Andrew don't have that
much more resources than you have.  They have programming skills
and lots of trust in the community.

>> You can, for example, maintain the same subsystem in parallel.  After a 
>> while,
>> all interested parties sees that your tree works better and that
>> communicating with you is easier.
>> If you aren't prepared to do this - then you have to live with the current
>> maintainer.  There is no staff ready to replace maintainers after
>> complaints, a volunteer doing a better job is always necessary.
>>     
>
> Neither nor: I do not livbe with persons like Chehab and others, no matter what the consequence is. To be truthful I would strategically prefare a vacuum at the price that the work isn't even done for months.
> ONLY IF there is a personnel vacuum the necessity for others to volunteer will arise.
>   
A sufficiently bad maintainer will also do it.  If lots of submitters send
their patches to andrew in order to get past a dysfunctional maintainer,
then the subsystem effectively is unmaintained.
> So if you want a real change you gotta first kick the reactionary dumb bastards off from their seats without any return ticket - without that there won't be any changes at all!
>   
Well then - create a patch to the MAINTAINERS file that removes this 
maintainer
leaving the position open.  Perhaps you can get that accepted despite the
existing maintainer - *if* you can get most other developers for that
subsystem to add signed-off lines.  It will then be clear that the
community agrees with you. 

However, if the bulk of them thinks the current maintainer is fine, then
it stays that way.  Satisfying everybody is unfortunately not always 
possible.
You can always try submitting your own patches above this maintainer.
> But the practice now is the typical "Sit out and do not react at all" behaviour as far as Chehab himself is concerned - Germans remember that reactionary gesture from the time when Hellmut Kohl was chancellor for 16 horrible years.....
>
> So there will be no "soft" or "polite" solution at all, but only a harsh and rude one:
> "Kick out the Jams!"
Dropping lazy or incompetent maintainers do happen occationally.
But don't let frustration lead to angry emails - all you get that way is 
lost
credibility, that will only make it harder to convince people.

Helge Hafting
