Return-Path: <linux-kernel-owner+w=401wt.eu-S932287AbYBGPC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbYBGPC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759497AbYBGPCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:02:46 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34899 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbYBGPCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:02:44 -0500
Message-ID: <47AB1D91.6090609@davidnewall.com>
Date: Fri, 08 Feb 2008 01:32:41 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Adrian Bunk <bunk@kernel.org>, Chris Friesen <cfriesen@nortel.com>,
       Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	<20080202123710.42df1aa0@weinigel.se>	<20080202191930.GA19826@kroah.com>	<20080203124849.0226560f@weinigel.se>	<84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com>	<47A5F418.6030104@weinigel.se>	<20080203231530.GB15692@kroah.com>	<courier.47A8EDDC.0000785F@hawking.rebel.net.au>	<47A8F27F.3060504@nortel.com>	<20080206210452.GB7198@cs181133002.pp.htv.fi>	<47AB06F9.30201@davidnewall.com> <20080207141557.5fcf3b2d@core>
In-Reply-To: <20080207141557.5fcf3b2d@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> IANAL, but when looking at the "But when you distribute the same 
>>> sections as part of a whole which is a work based on the Program, the 
>>> distribution of the whole must be on the terms of this License" of the 
>>> GPLv2 I would still consult a lawyer before e.g. selling a laptop with a 
>>> closed-source driver loaded through ndiswrapper.
>>>       
>> Don't ignore, "mere aggregation of another work not based on the Program
>> with the Program (or with a work based on the Program) on a volume of a
>> storage or distribution medium does not bring the other work under the
>> scope of this License."  Static linking certainly makes something part
>> of the whole; dynamic linking doesn't.
>>     
>
> Wrong again. You really are quite amusing.

I'm glad to entertain.  It's a pity you refuse to be educated.  Closed
mind on the topic, perhaps?


> The test is "derivative works" not linking.

That is one of the terms used.  Another, which I pointed out to your
apparent glee, is "aggregation."  Both terms are relevant only because
they were chosen for use in GPL.


> Linking is a meaningless (in law) computing term with no
> place. Legal precedent for combining of works is drawn from things like
> shipping a book and a commentary on the book together, putting music to
> films, putting photos in a book. These are not "linking"
>   
Whatever the precedent is, and I'll take your word on it even though
it's more hearsay, it's explicitly covered by that part of the licence
referring to "mere aggregation."

> And I know what the lawyers I've talked to have said about the case of
> shipping proprietary modules with the OS. Its a pretty definite "bad idea"

Now, that's more like it.  It sounds somewhat believable, unlike your
previous statements which seemed to say, "you've spoken to numerous
lawyers and they've all said that proprietary modules violate GPL."  I
paraphrased you, and if that's not what you meant then please take the
opportunity to refine your claims.  "Bad idea" is legal speak for, "I'll
fight it for you, but you can lose."  That's a big step away from
"dynamic modules must be governed by GPL."
