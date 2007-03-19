Return-Path: <linux-kernel-owner+w=401wt.eu-S964825AbXCSUnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825AbXCSUnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964824AbXCSUnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:43:46 -0400
Received: from mail.tmr.com ([64.65.253.246]:44086 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964825AbXCSUno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:43:44 -0400
Message-ID: <45FEF6D1.7020309@tmr.com>
Date: Mon, 19 Mar 2007 16:47:13 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Kasper Sandberg <lkml@metanurb.dk>
CC: Mike Galbraith <efault@gmx.de>,
       Radoslaw Szkodzinski <astralstorm@gmail.com>,
       Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ck@vds.kolivas.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>
Subject: Re: [ck] Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com>	 <200703172048.46267.kernel@kolivas.org>	 <1174125534.7734.2.camel@Homer.simpson.net>	 <200703172355.30989.a1426z@gawab.com>	 <1174198651.8199.44.camel@Homer.simpson.net>	 <1174200463.10498.23.camel@localhost>	 <1174201726.8732.6.camel@Homer.simpson.net>	 <f44c5fdf0703180022n44b2ca61o62602e54aaab3334@mail.gmail.com>	 <1174203482.8855.8.camel@Homer.simpson.net> <1174211853.10498.25.camel@localhost>
In-Reply-To: <1174211853.10498.25.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kasper Sandberg wrote:
> On Sun, 2007-03-18 at 08:38 +0100, Mike Galbraith wrote:
>> On Sun, 2007-03-18 at 08:22 +0100, Radoslaw Szkodzinski wrote:
>>
>>> I'd recon KDE regresses because of kioslaves waiting on a pipe
>>> (communication with the app they're doing IO for) and then expiring.
>>> That's why splitting IO from an app isn't exactly smart. It should at
>>> least be ran in an another thread.
>> Hm.  Sounds rather a lot like the...
>> X sucks, fix X and RSDL will rock your world.  RSDL is perfect.
>> ...that I've been getting.
>>
> not really, only X sucks. KDE works atleast as good with rsdl as
> vanilla. i dont know how originally said kde works worse, wasnt it just
> someone that thought?
> 
It was probably me, and I had the opinion that KDE is not as smooth as 
GNOME with RSDL. I haven't had time to measure, but using for daily 
stuff for about an hour each way hasn't changed my opinion. Every once 
in a while KDE will KLUNK to a halt for 200-300ms doing mundane stuff 
like redrawing a page, scrolling, etc. I don't see it with GNOME.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
