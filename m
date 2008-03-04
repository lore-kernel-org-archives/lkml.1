Return-Path: <linux-kernel-owner+w=401wt.eu-S1765720AbYCDS0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765720AbYCDS0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762670AbYCDS0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:26:22 -0500
Received: from rtr.ca ([76.10.145.34]:3323 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756819AbYCDS0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:26:20 -0500
Message-ID: <47CD944A.2090903@rtr.ca>
Date: Tue, 04 Mar 2008 13:26:18 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: saeed <saeed@marvell.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, jon@ngndg.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Sata-MV, Intergated Sata Device Support
References: <1176673884.5109.30.camel@Desktop> <47C35203.20402@garzik.org> <47C3585D.8070701@rtr.ca> <47C35A85.3020307@garzik.org> <alpine.DEB.0.99.0802260024400.22022@ubuntu-saeed.il.marvell.com> <47C43655.1050907@rtr.ca>
In-Reply-To: <47C43655.1050907@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> saeed wrote:
>>
>> On Mon, 25 Feb 2008, Jeff Garzik wrote:
>>
>>>> ...
>>>>
>>>> Saeed:  isn't this what your SOC patches already implemented for us?
>>>> As near as I can tell, sata_mv now already has support for the 60x1C0.
>>> Saeed's stuff didn't support PCI though, and Jon Li is definitely 
>>> talking
>>> about PCI...
>> yes, my patch added support for the SoC sata like in the 5182, and 
>> this is what Jon Li was concerned about. he mentioneded the 60x1C0 pci 
>> device just to suggest to use it's code for the SoC sata as it is very 
>> similar.
> ..
> 
> I don't think I understand your english there.
> 
> Does the current sata_mv driver work as-is with the chipset this person wants?
> If not, then exactly what has to change to make it work?
..

Saeed ??
