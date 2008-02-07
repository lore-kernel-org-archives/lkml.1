Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYBGNpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYBGNpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYBGNpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:45:18 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34846 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYBGNpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:45:16 -0500
Message-ID: <47AB0B67.7060103@davidnewall.com>
Date: Fri, 08 Feb 2008 00:15:11 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	 <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com>	 <47A5D9CD.5070001@davidnewall.com>	 <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>	 <47A5E67D.9040804@davidnewall.com> <1202058820.15090.60.camel@violet>	 <courier.47A84ADB.000047C1@hawking.rebel.net.au> <1202241819.15090.133.camel@violet>
In-Reply-To: <1202241819.15090.133.camel@violet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
>>> if a new drivers is originally written for Linux, then you are breaking
>>> the GPL.
>>>       
>> Completely wrong.  However if the driver is distributed as built-in, then it 
>> would need to be licensed under GPL.  This means that a driver can be 
>> written and distributed as a module under any licence, proprietary or 
>> otherwise, presumably with the restriction that it may NOT be built-in. 
>>     
>
> how to do you wanna write a new original Linux driver (modular or
> built-in) without creating derivative work.
>From what does it derive?  Given a new, original work, created from
scratch, could you point to another work, better yet show lines of code
in common?



>>> You driver was meant to be
>>> running as Linux kernel module and thus it is derivative work.
>>>       
>> It is precisely the fact that it is a loadable module, and does not form 
>> part of the kernel, that removes the requirement to distribute it under GPL. 
>>     
>
> That is such a nonsense. Stop distributing FUD and start talking to a
> lawyer. You are clearly under some weird impression what the GPL means
> and what it implies.
>   

It's nonsense, it's a reasonable reading of the GPL.  What I am doing is
telling you what the GPL says, not what you wish it said.

> If the developers say that this symbol can only be used in GPL code (and
> with EXPORT_SYMBOL_GPL it is quite clear) then you have to obey to that
> license or don't use this symbol at all.
>   
EXPORT_SYMBOL_GPL is not a licence.  Only a licence is a licence.

> If you use that symbol inside non-GPL (meaning you link at runtime) then
> you are in violation of the GPL license. We can't make it much clearer.
>   
Your desire is clear, but the facts are bound to disappoint you.

