Return-Path: <linux-kernel-owner+w=401wt.eu-S1030551AbXAaTRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030551AbXAaTRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 14:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030553AbXAaTRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 14:17:38 -0500
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:60425 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030551AbXAaTRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 14:17:37 -0500
Date: Wed, 31 Jan 2007 11:17:36 -0800 (PST)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
In-Reply-To: <Pine.LNX.4.61.0701311927170.13737@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0701311116240.9515@blackbox.fnordora.org>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
 <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
 <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com>
 <20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com>
 <Pine.LNX.4.61.0701311849490.13737@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0701310956540.8343@blackbox.fnordora.org>
 <Pine.LNX.4.61.0701311927170.13737@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007, Jan Engelhardt wrote:

>
> On Jan 31 2007 09:58, alan wrote:
>> On Wed, 31 Jan 2007, Jan Engelhardt wrote:
>>> On Jan 30 2007 14:00, Roland Dreier wrote:
>>>>
>>>> An uncharitable vendor might decide it's not worth publishing specs,
>>>> since the Linux guys can reverse engineer the Windows driver just as
>>>> fast anyway.
>>>
>>> And ndiswrapper gives fire to just releasing the Windows one :(
>>
>> ndiswrapper is a way to make it work "now" as opposed to "correct".
>> There is a lot that you cannot do with ndiswrapper that a proper driver
>> can.
>
> The fear is that a vendor might not open things because it works
> "reasonably enough" (for them as well as the enduser) at "this time".
> E.g. I got sis162u.inf for some usb wireless adapter, it works
> enough, but of course I am not too happy with the binary blob because
> it might have some not-so-"correct" core that could silently oops me
> away.

Of course, the vendors need to realize that such problems will be blamed 
on the hardware and not on the drivers.  "But I was using the Windows 
drivers!"

-- 
"Invoking the supernatural can explain anything, and hence explains nothing."
                   - University of Utah bioengineering professor Gregory Clark
