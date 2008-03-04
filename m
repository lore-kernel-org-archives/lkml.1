Return-Path: <linux-kernel-owner+w=401wt.eu-S1760627AbYCDVSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627AbYCDVSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYCDVSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:18:42 -0500
Received: from rtr.ca ([76.10.145.34]:4686 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbYCDVSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:18:41 -0500
Message-ID: <47CDBCAD.9040303@rtr.ca>
Date: Tue, 04 Mar 2008 16:18:37 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Byron Bradley <byron.bbradley@gmail.com>
Cc: saeed <saeed@marvell.com>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org, jon@ngndg.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Sata-MV, Intergated Sata Device Support
References: <1176673884.5109.30.camel@Desktop> <47C35203.20402@garzik.org>	 <47C3585D.8070701@rtr.ca> <47C35A85.3020307@garzik.org>	 <alpine.DEB.0.99.0802260024400.22022@ubuntu-saeed.il.marvell.com>	 <47C43655.1050907@rtr.ca> <57e2b00803041042k67f7b1c6ge8da83efaf1aa9f6@mail.gmail.com>
In-Reply-To: <57e2b00803041042k67f7b1c6ge8da83efaf1aa9f6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Byron Bradley wrote:
> On Tue, Feb 26, 2008 at 3:55 PM, Mark Lord <liml@rtr.ca> wrote:
>> saeed wrote:
>>  >
>>  > On Mon, 25 Feb 2008, Jeff Garzik wrote:
>>  >
>>  >>> ...
>>  >>>
>>  >>> Saeed:  isn't this what your SOC patches already implemented for us?
>>  >>> As near as I can tell, sata_mv now already has support for the 60x1C0.
>>  >> Saeed's stuff didn't support PCI though, and Jon Li is definitely talking
>>  >> about PCI...
>>  > yes, my patch added support for the SoC sata like in the 5182, and this
>>  > is what Jon Li was concerned about. he mentioneded the 60x1C0 pci device
>>  > just to suggest to use it's code for the SoC sata as it is very similar.
>>  ..
>>
>>  I don't think I understand your english there.
>>
>>  Does the current sata_mv driver work as-is with the chipset this person wants?
>>  If not, then exactly what has to change to make it work?
> 
> Jon Li was one of the people who started porting Linux to the Marvell
> Orion 88F5182 before Marvell did it. sata_mv does now work on the
> device Jon was talking about. When this was sent I think we were
> unsure whether it could work over PCI or just the system bus which
> probably confused things a little.
..

Thanks for pointing this out.

So, no further action required -- it already works now.

Got that, Jeff?

Cheers

