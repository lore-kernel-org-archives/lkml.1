Return-Path: <linux-kernel-owner+w=401wt.eu-S1760488AbYBGMwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488AbYBGMwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:52:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759554AbYBGMup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:50:45 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34767 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761086AbYBGMui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:50:38 -0500
Message-ID: <47AAFE91.1080104@davidnewall.com>
Date: Thu, 07 Feb 2008 23:20:25 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	<20080202123710.42df1aa0@weinigel.se>	<20080202191930.GA19826@kroah.com>	<20080203124849.0226560f@weinigel.se>	<84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com>	<47A5F418.6030104@weinigel.se>	<20080203231530.GB15692@kroah.com>	<courier.47A8EDDC.0000785F@hawking.rebel.net.au> <20080205231724.729a7a60@core>
In-Reply-To: <20080205231724.729a7a60@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>> If we're still talking about whether a kernel module is required to be 
>> released under GPL, then yes, this is not a gray area.  This is something 
>> that authors of original works can decide for themselves.  They have no 
>>     
                     ^^^^^^^^^^^^^^^

>
> Only if they are original works.
>   
Yes.  That was stipulated.

>   
>> obligation to release under GPL, however they must take special care to 
>> ensure that the module does not (statically) link with the kernel.  Richard 
>>     
>
> Also wrong.
>
> You really should investigate a beginners text on intellectual property
> law.

Perhaps you might read up on unfair trade practices and contract law. 
The contract (GPL) doesn't prevent me from using GPL work, in fact it
encourages me.  Neither can it impose conditions upon original work
authored by a third party.

You do realise, I suppose, that it's easily feasible to write a Linux
kernel module on a non-Linux platform, and in fact without even using
any GPL software in its production.  How could such a work possibly be
derivative?  How could it be affected by GPL?

And please, don't give wishy-washy "lawyers tell me it's so"
non-answers.  Give something real.
