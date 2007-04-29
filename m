Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbXD2HXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbXD2HXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbXD2HXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:23:07 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:36591 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755017AbXD2HXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:23:06 -0400
Date: Sat, 28 Apr 2007 23:43:09 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: David Miller <davem@davemloft.net>
cc: mrechberger@gmail.com, torvalds@linux-foundation.org, bunk@stusta.de,
       diegocg@gmail.com, cebbert@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.21
In-Reply-To: <20070428.204048.125894473.davem@davemloft.net>
Message-ID: <Pine.LNX.4.63.0704282339220.11975@qynat.qvtvafvgr.pbz>
References: <20070428195320.GZ3468@stusta.de><alpine.LFD.0.98.0704281529080.
 9964@woody.linux-foundation.org><d9def9db0704281558r57460a6ft76bbddcc480058
 eb@mail.gmail.com> <20070428.204048.125894473.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, David Miller wrote:

> 
> From: "Markus Rechberger" <mrechberger@gmail.com>
> Date: Sun, 29 Apr 2007 00:58:09 +0200
>
>> On 4/29/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>
>>>
>>> On Sat, 28 Apr 2007, Adrian Bunk wrote:
>>>>
>>>> We are already quite good at ignoring bug reports that come through
>>>> linux-kernel, and it's an _advantage_ of the kernel Bugzilla to see more
>>>> than 1600 open bugs because this tells how bad we are at handling bugs.
>>>
>>> No, it just shows that bugzilla doesn't matter for most of the kernel.
>>>
>>> Don't say that "bugzilla tells how bad we are at handling bugs". It tells
>>> how bad *bugzilla* is for handling bugs, nothing more.
>>>
>>
>> I totally disagree here, bugzilla is a very good tool.
>
> No, Bugzilla really does suck, and I personally refuse to use it when
> I have a choice.  And guess what?  You better be concerned about that
> because I maintain all of the networking code :-)
>
> It puts the onus FAR too much on the developer and not enough on the
> reporter and other minions.  We have a small resource of developers,
> yet lots of users, bug reporters, and minions, so something that
> doesn't take advantage of the larger resource we have is going to
> not function efficiently at all.  Yet that is what bugzilla does.

I'll say that as a user I hate having to deal with bugzilla.

there's nothing more frustrating then spending a good chunk of time trying to 
find a similar bug, then jumping through all the bugzilla hoops to file a report 
to eventually (days/weeks later) get a message 'closed becouse it's a duplicate 
report), then have to go and track down what it's a duplicate of, read through 
that bug report, only to find that it's not solved there either, and to top it 
off, the people working on that bug won't see my report or that I'm available to 
troubleshoot it.

from a user poit of view, e-mailing the kernel list (retrying a few days later 
of there is no response) tends to work _much_ better.

David Lang
