Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbXFOBua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbXFOBua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXFOBuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:50:23 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:3348 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbXFOBuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=VZJsi3Ldnp1MJ7fdxyM8dnuo4uMDr+2M1HD8rZSJT1WwaJTmNSH99mmezLkQGTZaQVIixR4lizgyKPFacI0q0K0YYVxVBK8+vqQr8YUQJtzrb+VYllXzbbtFlGp/baNvyqIE3Q+LUo/wddPw5laLsVnt9dGXMMQuZ9j/RL64do8=
Message-ID: <4671F127.40000@gmail.com>
Date: Thu, 14 Jun 2007 21:53:43 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061027)
MIME-Version: 1.0
To: Alexandre Oliva <aoliva@redhat.com>
CC: Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>	<alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>	<ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>	<200706140305.50095.dhazelton@enter.net>	<orr6oefpg4.fsf@oliva.athome.lsd.ic.unicamp.br>	<46717C58.8050501@gmail.com>	<ord4zye6iv.fsf@oliva.athome.lsd.ic.unicamp.br>	<4671A528.5040300@gmail.com> <or1wge9pwr.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or1wge9pwr.fsf@oliva.athome.lsd.ic.unicamp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2007 05:39 PM, Alexandre Oliva wrote:
> On Jun 14, 2007, Florin Malita <fmalita@gmail.com> wrote:
>   
>> No, it's not: replacing does not create derivative
>> work. Modification does.
>>     
>
> Thanks.  Good point.  This convinces me that this doesn't work as a
> legal argument under copyright.
>
> I still stand by my understanding that this restriction violates the
> spirit of the license.
>   

But since this elusive "spirit" is subject to everybody's interpretation 
of the preamble, you must surely admit that it remains just a matter of 
opinion ;)

>> It seems pretty obvious that the only right Tivo is withholding is the
>> right to install new versions on the device
>>     
>
> Actually, no.  They withhold the right to run versions that they don't
> authorize themselves.
>   

On that particular piece of hw, yes. But who's granted you the right to 
*run* your modified copy *there* in the first place? GPLv2 explicitly 
steers clear of anything "other than copying, distribution and 
modification".

> Back when GPLv2 was written, the right to run was never considered an
> issue.  It was taken for granted, because copyright didn't control
> that in the US (it does in Brazil), and nobody had thought of
> technical measures to stop people from running modified copies of
> software.  At least nobody involved in GPLv2, AFAIK.
>   
> The landscape has changed, and GPLv3 is meant to defend this freedom
> that was taken for granted.
>   

Then you agree that GPLv2 does not protect your freedom (taken for 
granted) to run a modified copy on any particular device, or am I 
misreading?

>>> What do you think you do when you save a modified source file in your
>>> editor?
>>>       
>
>   
>> Don't skip the part where the in-memory version started as an exact
>> copy of the original being replaced. Notice the difference? ;)
>>     
>
> Sorry, I really don't follow.  Both versions of the kernel binary also
> started from a common source ancestor.  Were you trying to make a
> distinction on these grounds?
>   

Exactly: they have a common ancestor, they are both derived from it. But 
there's no ancestry relationship *between* them (unlike your edited file 
example) so you cannot argue that one is a modification of the other. 
Hence, Tivo is not really *modifying* the copies it distributes with the 
device - they're *installing* brand new copies instead. They also choose 
not to offer everybody the same privilege :-|

Does this go against the intent of the GPLv2 authors? Probably. Does it 
go against the letter of GPLv2? Apparently not. Does it go against 
your/some people's interpretation of the GPL "spirit"? Obviously. Does 
it go against everybody's interpretation? Obviously not.

---
fm
