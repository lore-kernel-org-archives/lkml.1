Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbXKKAGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbXKKAGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 19:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbXKKAGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 19:06:48 -0500
Received: from rtr.ca ([76.10.145.34]:3299 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578AbXKKAGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 19:06:48 -0500
Message-ID: <47364794.9010608@rtr.ca>
Date: Sat, 10 Nov 2007 19:06:44 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-usb-users@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       mdharm-usb@one-eyed-alien.net, dbrownell@users.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: USB storage: corrupted data transfers
References: <47361D24.8020708@rtr.ca> <47362573.4050309@rtr.ca>
In-Reply-To: <47362573.4050309@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mark Lord wrote:
>> Something may be broken in USB / usb-storage land.
>>
>> I've got a 2GB USB stick here.
>> I want to copy it to an image file on my hard drive:
>>
>>    cat /dev/sdb > usbkey.image1
>>
>> Make a second copy, with or without unplugging/replugging the stick:
>>
>>    cat /dev/sdb > usbkey.image2
>>
>> After doing this, the two copies *differ*.
> 
> Here's the information on the specific devices I'm trying this with.
> 
> I'm beginning to suspect a faulty stick, or maybe one that just doesn't
> work reliably with the way Linux accesses it (?).  The type that fails
...

Yup, bad hardware.  I've got 13 of those sticks here, and 11 are fine.

Move along folks, nothing to see here..  :)
