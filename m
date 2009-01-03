Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbZACEsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbZACEsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 23:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbZACEsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 23:48:46 -0500
Received: from main.gmane.org ([80.91.229.2]:32845 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbZACEsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 23:48:46 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: ath9k microwave anomaly
Date: Fri, 02 Jan 2009 22:48:29 -0600
Message-ID: <495EEE1D.8050500@shaw.ca>
References: <495ED1C4.8020304@gmail.com> <20090103032134.GA20209@redhat.com>	 <495EDC10.20605@gmail.com> <f488382f0901021949y60b6d60fjeaeb6bb12a851f8@mail.gmail.com> <495EE2A0.2080703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Steven Noonan <steven@uplinklabs.net>, Dave Jones <davej@redhat.com>
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
In-Reply-To: <495EE2A0.2080703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> Steven Noonan wrote:
>> On Fri, Jan 2, 2009 at 7:31 PM, Justin P. Mattock
>> <justinmattock@gmail.com> wrote:
>>  
>>> Dave Jones wrote:
>>>    
>>>> On Fri, Jan 02, 2009 at 06:47:32PM -0800, Justin P. Mattock wrote:
>>>>  > Now I'm not trying to be funny,
>>>>  > but I think I figured a problem
>>>>  > with running ath9k, and having the internet
>>>>  > timeout.(for me at least);
>>>>  > When streaming T.V.(cspan2), and
>>>>  > streaming music(somafm), at the same time,
>>>>  > then using the microwave, I'll experience a blackout
>>>>  > of internet(T.V. stops, then music stops streaming);
>>>>
>>>> not specific to ath9k.
>>>>
>>>> http://blogs.zdnet.com/Ou/?p=578 has some pretty graphics
>>>> to show just how much noise a microwave puts into the part
>>>> of the spectrum wifi uses.
>>>>
>>>>        Dave
>>>>
>>>>
>>>>       
>>> Damn that's allot,
>>> no wonder I was having these timeouts.
>>> i.g. system streams fine for 10 hours.
>>> then the next day a timeout after 2 hours due
>>> to microwave use.
>>> Thanks for pointing that blog out.
>>> that opened my eyes up to how powerful
>>> a microwave is. makes me wonder if that
>>> grade in the window actually does what is supposed to.
>>> (block gamma rays or whatever the dangerous wave is);
>>>
>>> regards;
>>>
>>> Justin P. Mattock
>>>
>>>     
>> Yeah, I think it was Luis Rodriguez (from Atheros) who told me that a
>> microwave was the best way to make a signal "wet poop" for
>> interference testing.
>>
>>   
> Well, this one here seems to be not
> that old, but it's enough to cause
> interference. Hopefully not too old
> to cause me to go sterile!!
> interesting thing is when
> the microwave is cold and then started
> I noticed more interference, as to when
> it's been running for a while.

I think the standards for microwaves allow a reasonable amount of 
microwave leakage - still way below the levels that can harm you, but 
compared to the power levels that a WiFi device puts out, it's pretty 
significant..

