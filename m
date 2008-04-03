Return-Path: <linux-kernel-owner+w=401wt.eu-S1761315AbYDCT5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315AbYDCT5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbYDCT5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:57:06 -0400
Received: from mail.lang.hm ([64.81.33.126]:48100 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947AbYDCT5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:57:05 -0400
Date: Thu, 3 Apr 2008 13:04:16 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Xavier Bestel <xavier.bestel@free.fr>
cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ASUS ScreenDuo
In-Reply-To: <1207251545.24007.3.camel@bip.parateam.prv>
Message-ID: <alpine.DEB.1.10.0804031303210.22292@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0804031506300.7376-100000@iolanthe.rowland.org> <1207251545.24007.3.camel@bip.parateam.prv>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Xavier Bestel wrote:

> On jeu, 2008-04-03 at 15:07 -0400, Alan Stern wrote:
>> On Thu, 3 Apr 2008, Xavier Bestel wrote:
>>
>>> On jeu, 2008-04-03 at 11:37 -0400, Alan Stern wrote:
>>>> On Thu, 3 Apr 2008, Xavier Bestel wrote:
>>>>
>>>>> Hi,
>>>>>
>>>>> I have an ASUS motherboard with an USB gadget, the ASUS ScreenDUO. It's
>>>>> an independant little lcd screen with buttons, apparently it runs some
>>>>> kind of OS because it can access the net (e.g. to retrieve RSS) even
>>>>> when the computer is off - I guess they mean soft-off.
>>>>>
>>>>> Well, all that is theory because it's under Vista, which I don't have.
>>>>> Under Linux the ScreenDUO is kind-of recognized: it says it's a mass
>>>>> storage device, but I can't mount it (the kernel says it's bound to sdc,
>>>>> but sdc doesn't exist).
>>>>> I'd like to access it. Does anyone know how that thing works ?
>>>>
>>>> What does usbmon show when you modprobe usb-storage?  (The instructions
>>>> for usbmon are in the kernel source file Documentation/usb/usbmon.txt.)
>>
>> ...
>>
>> The ScreenDUO is reporting that no medium is present.  Maybe it needs
>> you to insert some sort of flash memory card before it will work as a
>> mass-storage device.
>
> Ah. Apparently it just waits for some driver from the Windows side (no
> way to insert anything in there).
> I guess it'll just be another useless piece of electronics at home.

for future use, what was it that made everyone decide that this is going 
to show up as a storage device?

with a screen and buttons I would have guessed a HID of some sort.

David Lang
