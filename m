Return-Path: <linux-kernel-owner+w=401wt.eu-S934347AbYCENH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347AbYCENH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933324AbYCENHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:07:22 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44009 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933044AbYCENHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:07:20 -0500
Message-ID: <47CE9B03.9040100@garzik.org>
Date: Wed, 05 Mar 2008 08:07:15 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Byron Bradley <byron.bbradley@gmail.com>, saeed <saeed@marvell.com>,
       linux-ide@vger.kernel.org, jon@ngndg.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Sata-MV, Intergated Sata Device Support
References: <1176673884.5109.30.camel@Desktop> <47C35203.20402@garzik.org>	 <47C3585D.8070701@rtr.ca> <47C35A85.3020307@garzik.org>	 <alpine.DEB.0.99.0802260024400.22022@ubuntu-saeed.il.marvell.com>	 <47C43655.1050907@rtr.ca> <57e2b00803041042k67f7b1c6ge8da83efaf1aa9f6@mail.gmail.com> <47CDBCAD.9040303@rtr.ca>
In-Reply-To: <47CDBCAD.9040303@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Byron Bradley wrote:
>> On Tue, Feb 26, 2008 at 3:55 PM, Mark Lord <liml@rtr.ca> wrote:
>>> saeed wrote:
>>>  >
>>>  > On Mon, 25 Feb 2008, Jeff Garzik wrote:
>>>  >
>>>  >>> ...
>>>  >>>
>>>  >>> Saeed:  isn't this what your SOC patches already implemented for 
>>> us?
>>>  >>> As near as I can tell, sata_mv now already has support for the 
>>> 60x1C0.
>>>  >> Saeed's stuff didn't support PCI though, and Jon Li is definitely 
>>> talking
>>>  >> about PCI...
>>>  > yes, my patch added support for the SoC sata like in the 5182, and 
>>> this
>>>  > is what Jon Li was concerned about. he mentioneded the 60x1C0 pci 
>>> device
>>>  > just to suggest to use it's code for the SoC sata as it is very 
>>> similar.
>>>  ..
>>>
>>>  I don't think I understand your english there.
>>>
>>>  Does the current sata_mv driver work as-is with the chipset this 
>>> person wants?
>>>  If not, then exactly what has to change to make it work?
>>
>> Jon Li was one of the people who started porting Linux to the Marvell
>> Orion 88F5182 before Marvell did it. sata_mv does now work on the
>> device Jon was talking about. When this was sent I think we were
>> unsure whether it could work over PCI or just the system bus which
>> probably confused things a little.
> ..
> 
> Thanks for pointing this out.
> 
> So, no further action required -- it already works now.
> 
> Got that, Jeff?

hehe, thanks :)


