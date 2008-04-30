Return-Path: <linux-kernel-owner+w=401wt.eu-S1765050AbYD3X4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765050AbYD3X4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbYD3Xz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:55:57 -0400
Received: from mail.lang.hm ([64.81.33.126]:57026 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786AbYD3Xz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:55:56 -0400
Date: Wed, 30 Apr 2008 16:57:38 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <200805010145.39373.rjw@sisk.pl>
Message-ID: <alpine.DEB.1.10.0804301654200.7807@asgard>
References: <20080429.190352.137408408.davem@davemloft.net> <200805010023.32213.rjw@sisk.pl> <alpine.DEB.1.10.0804301528250.7807@asgard> <200805010145.39373.rjw@sisk.pl>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008, Rafael J. Wysocki wrote:

> On Thursday, 1 of May 2008, david@lang.hm wrote:
>> On Thu, 1 May 2008, Rafael J. Wysocki wrote:
>>
>>> On Wednesday, 30 of April 2008, Linus Torvalds wrote:
>>>>
>>>> On Wed, 30 Apr 2008, Rafael J. Wysocki wrote:
>>>> So your "fewer commits over a unit of time" doesn't make sense.
>>>
>>> Oh, yes it does.  Equally well you could say that having brakes in a car
>>> didn't make sense, even if you could drive it as fast as the engine allowed
>>> you to. ;-)
>>>
>>>> We have those ten thousand commits. They need to go in. They cannot take
>>>> forever.
>>>
>>> But perhaps some of them can wait a bit longer.
>>
>> not really, if patches are produced at a rate of 1000/week and you decide
>> to only accept 2000 of them this month, a month later you have 6000
>> patches to deal with.
>
> Well, I think you know how TCP works.  The sender can only send as much
> data as the receiver lets it, no matter how much data there are to send.
> I'm thinking about an analogous approach.
>
> If the developers who produce those patches know in advance about the rate
> limit and are promised to be treated fairly, they should be able to organize
> their work in a different way.

they will make the patches bigger to get the changes in a smaller number 
of patches. arbatrary limits produce gaming the system :-)

>> history has shown that developers do not stop developing if their patches are
>> not accepted, they just fork and go their own way.
>
> That's mostly when they feel that they are treated unfairly.
>
> OTOH, insisting that your patches should be merged at the same rate that you're
> able to develop them is unreasonable to me.

it's not nessasarily the individuals that fork, it's the distros who want 
to include the fixes and other changes that the individuals that create 
the fork.

David Lang
