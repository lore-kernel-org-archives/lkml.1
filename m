Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbYBGObk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbYBGObk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbYBGOb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:31:28 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34869 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbYBGOb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:31:27 -0500
Message-ID: <47AB163C.5070107@davidnewall.com>
Date: Fri, 08 Feb 2008 01:01:24 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: =?UTF-8?B?SGFucy1Kw7xyZ2VuIEtvY2g=?= <hjk@linutronix.de>
CC: Christer Weinigel <christer@weinigel.se>,
       Marcel Holtmann <marcel@holtmann.org>,
       Diego Zuccato <diego@otello.alma.unibo.it>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	<20080202123710.42df1aa0@weinigel.se>	<20080202191930.GA19826@kroah.com>	<47A5D895.20300@davidnewall.com>	<47A6E742.80408@otello.alma.unibo.it>	<47A764ED.8030605@weinigel.se>	<1202161091.15090.84.camel@violet>	<20080206213449.6614efea@weinigel.se>	<20080206215442.63c94cf3@dilbert.local>	<47AB056E.70802@davidnewall.com> <20080207150612.21ba60df@dilbert.local>
In-Reply-To: <20080207150612.21ba60df@dilbert.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Jürgen Koch wrote:
> Am Thu, 07 Feb 2008 23:49:42 +1030
> schrieb David Newall <davidn@davidnewall.com>:
>   
>> Nobody is saying "I don't like your licence."  The issue is a
>> technical restriction in Linux that attempts to restrict non-GPL
>> software from running under it.  
>>     
>
> What are you trying to say? You like the license but you're against
> enforcing it? 
>   

I told you: the GPL does not preclude inter-operation with non-GPL software.

>> It's a bullish approach, technically incompetent,
>>     
>
> What's incompetent?
>   
It's easily defeated.

>> legally meaningless
>>     
>
> It is not legally meaningless if copyright holders publicly state how
> they interpret the license and what they consider a license violation.
>   

Copyright-holders' opinions mean nothing.  In the particular case of
EXPORT_SYMBOL_GPL, copyright-holders' opinions are clearly flawed
because they make a statement about code that they do not even know of. 
It's equivalent to someone saying, "you are wrong," before you've even
thought about saying something.

> In the end, a court must decide, but lots of courts will at least look
> at the statements the copyright holders made over the years.
>
>   
>> and politically damaging.
>>     
>
> That's your opinion because it's damaging _your_ political goals.
>   

How ludicrous.  That's as much a nonsense as EXPORT_SYMBOL_GPL.  You
have no idea what my political goals are.

Less there be further confusion: I am not an advocate for binary
drivers.  That role is reserved for others.  However that does not stop
me from criticising something that is obviously wrong.  Stating that
only a GPL code is permitted to use a symbol contravenes the GPL,
because the GPL states no such requirement.  Saying that it's impossible
for code that uses the symbol to be non-GPL (as has been claimed) is a
lie at worst, and a hope at best.  Nobody claiming such a thing could
know it to be true.  (It is not true.)
