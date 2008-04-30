Return-Path: <linux-kernel-owner+w=401wt.eu-S933716AbYD3Wi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716AbYD3Wi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760275AbYD3Wip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:38:45 -0400
Received: from mail.lang.hm ([64.81.33.126]:34671 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432AbYD3Win (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:38:43 -0400
Date: Wed, 30 Apr 2008 15:40:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <200805010023.32213.rjw@sisk.pl>
Message-ID: <alpine.DEB.1.10.0804301528250.7807@asgard>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008, Rafael J. Wysocki wrote:

> On Wednesday, 30 of April 2008, Linus Torvalds wrote:
>>
>> On Wed, 30 Apr 2008, Rafael J. Wysocki wrote:
>> So your "fewer commits over a unit of time" doesn't make sense.
>
> Oh, yes it does.  Equally well you could say that having brakes in a car
> didn't make sense, even if you could drive it as fast as the engine allowed
> you to. ;-)
>
>> We have those ten thousand commits. They need to go in. They cannot take
>> forever.
>
> But perhaps some of them can wait a bit longer.

not really, if patches are produced at a rate of 1000/week and you decide 
to only accept 2000 of them this month, a month later you have 6000 
patches to deal with. history has shown that developers do not stop 
developing if their patches are not accepted, they just fork and go their 
own way.

David Lang

