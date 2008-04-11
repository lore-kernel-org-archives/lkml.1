Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbYDKNTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbYDKNTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 09:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbYDKNTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 09:19:23 -0400
Received: from rtr.ca ([76.10.145.34]:1031 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYDKNTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:19:22 -0400
Message-ID: <47FF6555.50004@rtr.ca>
Date: Fri, 11 Apr 2008 09:19:17 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: =?UTF-8?B?SWxwbyBKw6RydmluZW4=?= <ilpo.jarvinen@helsinki.fi>
Cc: David Miller <davem@davemloft.net>, jesper.juhl@gmail.com, tilman@imap.cc,
       yoshfuji@linux-ipv6.org, Jeff Garzik <jeff@garzik.org>, rjw@sisk.pl,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.25-rc8: FTP transfer errors
References: <47FEADCB.7070104@rtr.ca> <20080410.172453.44434205.davem@davemloft.net> <47FEB062.3020003@rtr.ca> <20080410.173911.179180620.davem@davemloft.net> <47FEBDAA.7010305@rtr.ca> <Pine.LNX.4.64.0804110849520.28360@wrl-59.cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0804110849520.28360@wrl-59.cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo Järvinen wrote:
> On Thu, 10 Apr 2008, Mark Lord wrote:
> 
>> David Miller wrote:
>>> From: Mark Lord <lkml@rtr.ca>
>>> Date: Thu, 10 Apr 2008 20:27:14 -0400
>>>
>>>> It's *your* bug -- you signed off on the commit.
>>> I sign off on basically every networking commit, does that mean I have
>>> to fix every networking bug and every networking bug is "mine"?
>> ..
>>
>> Absolutely, though to a varying degree.  That's the responsibility
>> that goes with the role of a subsystem maintainer.  I once had
>> such a role, and gave it up when I felt I could no longer keep up.  
>> You still keep refering to it as "your (my) bug".
>> It's not.  I had nothing to do with it, other than stumbling over it.
> 
> This bug is perfect example where bisect clearly was useful :-). Nobody 
> knew whose bug it actually was until your bisect gave directions.
> 
>> When people stumble over a libata bug, I look hard to see if my code
>> could possibly cause it.  Jeff looks even harder, because he's the
>> current subsystem dude for libata.
>>
>> I never suggest a user search through a mountain of unrelated commits
>> for something I've screwed up on.
> 
> But it is ok for you to ask an innocent net developer to do that (even 
> with your terms as I hadn't signed off _anything_ related to that one),
> hmm?
> 
> ...You had this pretty demanding tone earlier:
> 
>> Or I can ignore it, like the net developers, since I have a workaround.
>> And then we'll see what other apps are broken upon 2.6.25 final release.
..

That's not demanding, that's quite relaxed.  I had a good workaround,
and didn't really care any more at that point.  Just though it was rather
odd that none of the developers seemed interested in tracking it down.
I offered tons of help, gave it, and said I didn't have time for a full
bisect at that juncture.

For that, I get repeatedly slammed by the netdev folks.
Even after I put aside *paid* work to submit to your demands.

Next time around, I won't bother reporting bugs to you folks,
that's for damned sure.

Cheers
