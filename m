Return-Path: <linux-kernel-owner+w=401wt.eu-S1763914AbXGFP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763914AbXGFP6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762145AbXGFP6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:58:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42999 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbXGFP6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:58:08 -0400
Message-ID: <468E6717.3040603@oracle.com>
Date: Fri, 06 Jul 2007 09:00:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, gregkh@suse.de
Subject: Re: [PATCH] USB:  Remove Makefile reference to obsolete OHCI_AT91.
References: <Pine.LNX.4.64.0707060623170.11885@localhost.localdomain> <20070706084910.4e5fc20f.randy.dunlap@oracle.com> <Pine.LNX.4.64.0707061152090.32394@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707061152090.32394@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Fri, 6 Jul 2007, Randy Dunlap wrote:
> 
>> On Fri, 6 Jul 2007 06:24:20 -0400 (EDT) Robert P. J. Day wrote:
>>
>>> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>>>
>>> ---
>>>
>>> diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
>>> index 72464b5..4d65404 100644
>>> --- a/drivers/usb/Makefile
>>> +++ b/drivers/usb/Makefile
>>> @@ -15,7 +15,6 @@ obj-$(CONFIG_USB_OHCI_HCD)	+= host/
>>>  obj-$(CONFIG_USB_UHCI_HCD)	+= host/
>>>  obj-$(CONFIG_USB_SL811_HCD)	+= host/
>>>  obj-$(CONFIG_USB_U132_HCD)	+= host/
>>> -obj-$(CONFIG_USB_OHCI_AT91)	+= host/
>>>
>>>  obj-$(CONFIG_USB_ACM)		+= class/
>>>  obj-$(CONFIG_USB_PRINTER)	+= class/
>>> --
>> Please use subsystem mailing lists instead of using lkml for
>> Everything:
> 
> that's what i would normally do, except a couple times when i did
> that, i was chided for not posting to the main list.  i'll deal just
> with the subsystem lists from now on.

Thanks.  I missed that chiding that you refer to.  It was incorrect.

-- 
~Randy
