Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbYBGNBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbYBGNBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYBGNAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:00:54 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34779 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYBGNAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:00:53 -0500
Message-ID: <47AB0101.2050204@davidnewall.com>
Date: Thu, 07 Feb 2008 23:30:49 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Diego Zuccato <diego@otello.alma.unibo.it>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	<20080202123710.42df1aa0@weinigel.se>	<20080202191930.GA19826@kroah.com>	<47A5D895.20300@davidnewall.com>	<47A6E742.80408@otello.alma.unibo.it>	<courier.47A8F072.000079E4@hawking.rebel.net.au> <20080205232550.5d3d22ff@core>
In-Reply-To: <20080205232550.5d3d22ff@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> "Of course", because in many parts of the world, a device who's manufacturer 
>> fails to take reasonable steps to prevent it from being used outside 
>> regulatory limits is illegal.  Providing source code not only is a failure 
>> to take those reasonable steps, but is quite the opposite.  It may even be 
>> viewed as encouraging users to use it inappropriately.
>>     
>
> To my knowledge there is no caselaw on this for software,

In Australia, devices require approval from a regulatory body.  Such
approval is withheld if appropriate safeguards are not applied.


>  nor is it
> clearly so simple - many vendors do provide source, many vendors provide
> windows drivers where any end user can click to specify their country and
> can lie trivially. Many users retrofit US firmware to non US devices and
> its trivial to do. Its a hard problem
Yes it is; but what is simple, is to understand that lack of such
safeguards, even though they are imperfect, does result in refusal to
approve.

> Some (particularly US) companies choose to take a conservative view based
>   
Also, particularly Australia and New Zealand.  I can't imagine France or
Germany would be different.  Where is it different?
> on their pessimistic reading of the intent of the US regulator plus the
> ability of the regulator to do a lot of damage to their business.
>
> The notion they are illegal is a real unknown and the market seems split
> on views of this.
>   

That is what I was saying: To require that only GPL-licenced USB drivers
may be used with Linux puts Linux at a disadvantage in the market.  The
embedded market is simply huge.  Microsoft would _love_ Linux to fail
there, because that's what's necessary for Wince to win.
