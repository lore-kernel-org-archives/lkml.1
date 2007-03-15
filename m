Return-Path: <linux-kernel-owner+w=401wt.eu-S1751295AbXCOSSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbXCOSSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 14:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbXCOSSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 14:18:15 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:2573 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbXCOSSO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 14:18:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 15 Mar 2007 18:18:11.0556 (UTC) FILETIME=[4A454A40:01C7672E]
Content-class: urn:content-classes:message
Subject: Re: USB Keyboard
Date: Thu, 15 Mar 2007 14:18:11 -0400
Message-ID: <Pine.LNX.4.61.0703151413160.4212@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.64.0703151851190.12394@twin.jikos.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: USB Keyboard
Thread-Index: AcdnLkpOaqsD69+3Rpyr2GxTzS8Peg==
References: <Pine.LNX.4.61.0703151331060.4442@chaos.analogic.com> <Pine.LNX.4.64.0703151835150.12394@twin.jikos.cz> <Pine.LNX.4.61.0703151345010.4487@chaos.analogic.com> <Pine.LNX.4.64.0703151851190.12394@twin.jikos.cz>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Mar 2007, Jiri Kosina wrote:

> (added linux-usb-devel@lists.sourceforge.net to CC)
>
> On Thu, 15 Mar 2007, linux-os (Dick Johnson) wrote:
>
>>>> I have multiple AMD 64-bit servers in several configurations, with
>>>> several different motherboards, which fail to recognize a USB keyboard
>>>> when booted from a "stock" Linux kernel. They only work with a RedHat
>>>> kernel! I have removed all but one CPU from one in an attempt to find
>>>> the problem.
>>> [...]
>>>> linux-2.6.8 linux-2.6.9 linux-2.6.10 linux-2.6.11
>>>> linux-2.6.11.9 linux-2.6.12 linux-2.6.12.5 linux-2.6.13
>>>> linux-2.6.13.4 linux-2.6.15.4 linux-2.6.16.24 linux-2.6.16.4
>>>> linux-2.6.19
>>> Could you please turn on USB debugging (and also maybe HID debugging, but
>>> usb debug should be more interesting now) and send us the logs?
>> Ouch!  I can't do anything by copy from a screen! There is no way to get
>> `dmesg` without the keyboard! That's why I sent a request to
>> linux-kernel, hoping that the problem would sound familiar. All I can do
>> is boot the system (off a CD-ROM) and then pull the plug when the
>> keyboad doesn't work!
>
> You state that this happens on different hardware configurations, which
> looks pretty strange, there are many 64bit amd systems with working USB
> keyboards.
>
> Do you happen to have USB Legacy setting in BIOS? If so, could you try
> turning it off?

I will turn it OFF, if ON. I just recompiled the drivers with USB debugging
turned ON and I tried it on a machine that works. There are few enough
debugging messages so I will be able to copy off the screen. I now need
to wait in line to use the machine (about an hour or so), then I will
get back to you.

>
> Also, does this happen only with one particular type of keyboard, or with
> various ones?
>

Any keyboards I have tried including the Dell keyboards we have laying
all over the place. I even tried an Apple keyboard because they are
different. I didn't expect to "work," only to be recognized as a keyboard.


> -- 
> Jiri Kosina
>

I'll get back to you in about an hour.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5615.29 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
