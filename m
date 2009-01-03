Return-Path: <linux-kernel-owner+w=401wt.eu-S932609AbZACILb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbZACILb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 03:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbZACILW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 03:11:22 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:26801 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZACILV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 03:11:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CsBZGzm3q3ajDWyvMxaxQQLGsQniWCW2hhrGUe4ZDnaiXseVBA7aaLVvACOpV+BPRb
         +8NKNCCWTYqIEBzajc9r1bQoOiOuIqZTkCd5VOIF3ZLTDouLLtAj30J9uj092BvOSp2R
         9H6oqrBMLp2odio5GGYtHToeqk/AaDXgN2I4o=
Message-ID: <495F1DA3.7060706@gmail.com>
Date: Sat, 03 Jan 2009 00:11:15 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       Steven Noonan <steven@uplinklabs.net>, Dave Jones <davej@redhat.com>
Subject: Re: ath9k microwave anomaly
References: <495ED1C4.8020304@gmail.com> <20090103032134.GA20209@redhat.com> <495EDC10.20605@gmail.com> <f488382f0901021949y60b6d60fjeaeb6bb12a851f8@mail.gmail.com> <495EE2A0.2080703@gmail.com> <495EEE1D.8050500@shaw.ca> <20090103073051.GC5038@1wt.eu>
In-Reply-To: <20090103073051.GC5038@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Fri, Jan 02, 2009 at 10:48:29PM -0600, Robert Hancock wrote:
>   
>> Justin P. Mattock wrote:
>>     
>>> Steven Noonan wrote:
>>>       
>>>> On Fri, Jan 2, 2009 at 7:31 PM, Justin P. Mattock
>>>> <justinmattock@gmail.com> wrote:
>>>>
>>>>         
>>>>> Dave Jones wrote:
>>>>>   
>>>>>           
>>>>>> On Fri, Jan 02, 2009 at 06:47:32PM -0800, Justin P. Mattock wrote:
>>>>>>             
>>>>>>> Now I'm not trying to be funny,
>>>>>>> but I think I figured a problem
>>>>>>> with running ath9k, and having the internet
>>>>>>> timeout.(for me at least);
>>>>>>> When streaming T.V.(cspan2), and
>>>>>>> streaming music(somafm), at the same time,
>>>>>>> then using the microwave, I'll experience a blackout
>>>>>>> of internet(T.V. stops, then music stops streaming);
>>>>>>>               
>>>>>> not specific to ath9k.
>>>>>>
>>>>>> http://blogs.zdnet.com/Ou/?p=578 has some pretty graphics
>>>>>> to show just how much noise a microwave puts into the part
>>>>>> of the spectrum wifi uses.
>>>>>>
>>>>>>       Dave
>>>>>>
>>>>>>
>>>>>>      
>>>>>>             
>>>>> Damn that's allot,
>>>>> no wonder I was having these timeouts.
>>>>> i.g. system streams fine for 10 hours.
>>>>> then the next day a timeout after 2 hours due
>>>>> to microwave use.
>>>>> Thanks for pointing that blog out.
>>>>> that opened my eyes up to how powerful
>>>>> a microwave is. makes me wonder if that
>>>>> grade in the window actually does what is supposed to.
>>>>> (block gamma rays or whatever the dangerous wave is);
>>>>>
>>>>> regards;
>>>>>
>>>>> Justin P. Mattock
>>>>>
>>>>>    
>>>>>           
>>>> Yeah, I think it was Luis Rodriguez (from Atheros) who told me that a
>>>> microwave was the best way to make a signal "wet poop" for
>>>> interference testing.
>>>>
>>>>  
>>>>         
>>> Well, this one here seems to be not
>>> that old, but it's enough to cause
>>> interference. Hopefully not too old
>>> to cause me to go sterile!!
>>> interesting thing is when
>>> the microwave is cold and then started
>>> I noticed more interference, as to when
>>> it's been running for a while.
>>>       
>> I think the standards for microwaves allow a reasonable amount of 
>> microwave leakage - still way below the levels that can harm you, but 
>> compared to the power levels that a WiFi device puts out, it's pretty 
>> significant..
>>     
>
> BTW, having any WiFi stopping working at 30 feet around a microwave oven
> makes me think that beast is leaking like mad. I've already ran experiences
> with mine in the past, and it could only slightly perturbate the traffic
> within one meter (3 ft) which I already considered huge. You may want to
> try to put some aluminium foil on the front door, it is possible that the
> protection grid is damaged or not properly sealed.
>
> Willy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
great!!
(should I build a cement barrier?);
I had timeouts like this with the wireless phone
(then went out a bought an encrypted phone for this purpose);
now the microwave is causing the same issue.(silently though);
like what I had mentioned, the microwave causes this when
it's cold started, making wonder if the waves are better handled
when the metal or grate is warm as opposed to cold.
(molecules are jumping around as opposed to moving around);
in any case as long as that microwave isn't active the internet
connection seems O.K.(knock on wood);

regards;

Justin P. Mattock
