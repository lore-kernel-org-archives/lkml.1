Return-Path: <linux-kernel-owner+w=401wt.eu-S935319AbYBGX2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935319AbYBGX2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760192AbYBGX1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:27:53 -0500
Received: from smtp-66.nebula.fi ([83.145.220.66]:56575 "EHLO
	smtp-66.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187AbYBGX1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:27:51 -0500
X-Greylist: delayed 2180 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2008 18:27:50 EST
Message-ID: <47AB8B6A.7020404@opensound.com>
Date: Fri, 08 Feb 2008 00:51:22 +0200
From: Hannu Savolainen <hannu@opensound.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Newall <davidn@davidnewall.com>, Chris Friesen <cfriesen@nortel.com>,
       Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	<20080202123710.42df1aa0@weinigel.se>	<20080202191930.GA19826@kroah.com>	<20080203124849.0226560f@weinigel.se>	<84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com>	<47A5F418.6030104@weinigel.se>	<20080203231530.GB15692@kroah.com>	<courier.47A8EDDC.0000785F@hawking.rebel.net.au>	<47A8F27F.3060504@nortel.com>	<47AB0238.5030400@davidnewall.com> <20080207141227.51193a12@core>
In-Reply-To: <20080207141227.51193a12@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox kirjoitti:
>> doesn't mean it's derived from Linux.  In the case of user-space code
>> it's widely understood that no licence restrictions are conferred.  The
>>     
>
> Actually that is also questionable. The only reason it is fairly certain
> in Linux is Linus went to the trouble of stating that interpretation was
> intended in the COPYING file and saying he sees it that way.
>
>   
>> No.  Holders of Linux copyrights would have to prove that the
>> proprietary code is derived from the kernel.  They have the burden of
>> proof, and defence needs merely show that their arguments are wrong.
>>     
>
> Wrong again. In civil law in the USA and most of europe the test is
> "balance of probability".
>   
What is the "propability" that drivers using the interfaces now declared 
as "EXPORT_SYMBOL_GPL" are derived from the Linux kernel source code 
instead of some definitive documentation?

As you all (should) know there is a book called "Linux Device Drivers, 
3rd Edition" published by O'Reilly (ISBN 0-596-00590-3)". All the USB 
kernel interfaces are documented there. One of the authors is Greg 
Kroah-Hartman which makes this book "definite" source of information on 
Linux USB driver programming. I assume Greg is the author of the USB 
related sections.

The "legal" question is what is that which one is license the one that 
applies? Is it the licecense of the kernel (GPL) or is it the license of 
the documentation (no restrictions on usage)?

The "moral" question is that why did Greg author a book that declares 
these USB interfaces as "free to use" and soon after that made a 
decision that they are no longer "free to use"?

Best regards,

Hannu


