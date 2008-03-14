Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYCNML0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYCNML0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 08:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYCNMLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 08:11:18 -0400
Received: from smtpauth02.prod.mesa1.secureserver.net ([64.202.165.182]:43572
	"HELO smtpauth02.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752500AbYCNMLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 08:11:17 -0400
Message-ID: <47DA6B62.5080103@seclark.us>
Date: Fri, 14 Mar 2008 08:11:14 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org
Subject: Re: linux+glibc memory allocator, poor performance
References: <998d0e4a0803121309s125dddbao801e53e44296a4d6@mail.gmail.com> <20080312211219.GL27894@ZenIV.linux.org.uk> <47D8C25A.8020708@davidnewall.com> <1205388732.4797.30.camel@marge.simson.net> <47D8C813.6020201@davidnewall.com> <84144f020803130210r1c7e8e11k7aedd3c60e7f5d0a@mail.gmail.com> <20080313121048.5b52b28b@the-village.bc.nu> <84144f020803130548o76f80fedm378f82e95c189ce2@mail.gmail.com> <47D98311.2040302@davidnewall.com> <20080313225040.GO27894@ZenIV.linux.org.uk>
In-Reply-To: <20080313225040.GO27894@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Fri, Mar 14, 2008 at 06:10:01AM +1030, David Newall wrote:
>   
>> Pekka Enberg wrote:
>>     
>>> Hi Alan,
>>>
>>> On Thu, Mar 13, 2008 at 2:10 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>>   
>>>       
>>>>  Politeness is a good thing this list needs more of.
>>>>     
>>>>         
>>> Do you honestly think we should be polite to people trolling on the
>>> LKML?
>>>       
>> I do.  It's obvious.  Rudeness detracts (and reflects poorly on one's
>> parents.)  Good manners cost nothing.  I might also point out that it
>> was bad manners, not any alleged trolling, which caused this sad
>> discussion.
>>     
>
> "Deliberate insult" would describe the original posting more accurately.
> Whether you prefer to look at it as a show of bad manners or as trolling
> is a matter of perspective; arguably it had been both.
>
>   
>> Don't be rude; rather say nothing.
>>     
>
> Request duly noted and denied.  For the record: condescending twits of that
> variety ("I can't be arsed to look at code I'm commenting on; here's my
> valuable insight that is obviously beyond the mental capacity of anybody
> here") can expect a harsh reply, whoever they are.  I'm yet to see l-k
> regulars treating newbies that way, BTW, despite the much decried lack of
> politeness.
>
> Since you are postulating social norms, here's one you seem to have overlooked:
> one who comments on code or design, be it review, suggestions of changes/
> improvements, etc., ought to read the thing he is commenting on.  Whoever
> it is and wherever the code in question might be.  And yes, it applies to
> kernel hackers commenting on newbies' patches to the same extent as to
> completely unknown folks commenting on the kernel, etc.
>
> Breaking that rule and being caught at that is one hell of a way to earn
> yourself a lousy reputation.  Combine that with arrogance and... well,
> there's a term for what you become: target practice.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
Someone once said:
"If you don't have anything good to say, don't day anything at all".

I have been reading LKML since the mid 90's and continually see people 
jump on
what are maybe dumb/stupid questions or trolls instead of simply 
ignoring them.

My $.02
Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



