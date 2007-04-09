Return-Path: <linux-kernel-owner+w=401wt.eu-S966122AbXDIQOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966122AbXDIQOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966118AbXDIQOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:14:10 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:44761 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966120AbXDIQOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:14:08 -0400
Message-ID: <461A6590.20501@student.ltu.se>
Date: Mon, 09 Apr 2007 18:10:56 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: johnrobertbanks@fastmail.fm
CC: Christer Weinigel <christer@weinigel.se>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-list@namesys.com
Subject: Re: Reiser4. BEST FILESYSTEM EVER - Christer Weinigel
References: <46157B5B.5000602@gmail.com>   <1175817921.18400.1183285196@webmail.messagingengine.com>   <461592FB.5060507@zytor.com>   <1175819681.20754.1183287946@webmail.messagingengine.com>   <461596DE.2020802@zytor.com>   <1175823288.25662.1183293506@webmail.messagingengine.com>   <4615C780.5040407@zytor.com>   <1175833931.8916.1183307802@webmail.messagingengine.com>   <20070407191715.GG3510@csclub.uwaterloo.ca>   <1175993097.32498.1183512070@webmail.messagingengine.com>   <m3zm5jebad.fsf@zoo.weinigel.se>   <1176069053.31062.1183584012@webmail.messagingengine.com>   <461973AD.5060906@student.ltu.se> <1176095658.16239.1183614988@webmail.messagingengine.com>
In-Reply-To: <1176095658.16239.1183614988@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

johnrobertbanks@fastmail.fm wrote:
> On Mon, 09 Apr 2007 00:58:53 +0200, "Richard Knutsson"
> <ricknu-0@student.ltu.se> said:
>   
>> Wow, I'm impressed. Think you got the record on how many mails you 
>> referenced to in a reply... 
>>     
>
> TWO actually. I guess you are easily impressed.
>   
Oh, took it to be from 5-6 sources...
>> + you have repeated the same statement several times, that is 
>> not the best way of convincing people.
>>     
>
> I know you DON'T believe that, as you are about the tenth person to
> repeat that "repeating stuff has no effect."
>   
Why should we change our response to the same error? The only solution 
to this loop is when people stops answering you and you "lose".
>> I believe you picked up the "anti-Reiser religion"-phrase from previous 
>> rant-wars (otherwise, why does that "religion"-phrase always come up, 
>> and (almost) only when dealing with Reiser-fs), and yes, there has been 
>> some clashes caused by both sides, so please be careful when dealing 
>> with this matter.
>>     
>
> NO. You people simply come across as zealots who work together, against
> Reiser4.
>
> Hence the term "anti-Reiser religion."
>   
Please, don't address someone you meet for the first time as "you people"!
Yes, we do _work_ together, it is a community and as a community you 
have to follow the social rules agreed upon. Without all those 
pro-Reiser peoples who knew how to work with the rest, there would not 
be a ResierFS/Reiser3 in the kernel. Unfortunately, Hans is in this case 
his own worst enemy and has ruffed quite a few feathers over the time. I 
don't think you would like someone who tells you "if you do it my way, 
then you are doing it wrong"...

But personally, even if I find Hans a bit too strong-headed, he got some 
interesting design-ideas and the Reiser-filesystem is something I think 
many find interesting as a concept but not yet trust-worthy for their 
own machines.
>> Would you be willing to benchmark Reiser4 with some compressed 
>> binary-blob and show the time as well as the CPU-usage? 
>>     
>
> I might be. I don't really know how to set it all up.
>
> Perhaps if you guided me through it.
>   
Am not sure how much help I would be but from the responses to your 
benchmark-list, there seems to be many who could help you. But first I 
think you should set up a system to test on, and then after some tests 
and made the result public, there will (most likely) be people who ask 
you to test it in some specific way.
>> I may have missed something, but if my room-mate took my harddrive, 
>> screwed it open, wrote a love-letter on the disk with a pencil and then 
>> returned it (ok, there may be some more plausible reasons for 
>> corruption), is the OS really suppose to handle it? 
>>     
>
> Yeah, I can't see how the OS could read the love-letter either.
>
> But one thing is for sure. The FS ain't responsible for reading it.
>   
And no-one has asked the file-system to _read_ the disk, but to be 
designed to help restore the file-structure. This I have found to be the 
main-point people complains about.
It is like arguing against air-bags in a car. Of course the car should 
not be responsible for preventing accidents, but they are designed so 
_if_ it happens, you should not be totally screwed.
>> Yes, it should not 
>> assign any new data to those blocks but should it not also fall into the 
>> file-systems domain to be able to restore some/all data?
>>     
>
> It's a tough ask of any FS. 
>
> Microsoft's filesystem checker totally roasted all my data on an XP-box
> last night. 
>   
Sorry to hear that, but two wrongs does not make it right.

Richard Knutsson

