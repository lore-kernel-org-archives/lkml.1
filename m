Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbXLKTau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbXLKTau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbXLKTam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:30:42 -0500
Received: from rtr.ca ([76.10.145.34]:2506 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbXLKTal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:30:41 -0500
Message-ID: <475EE560.6040601@rtr.ca>
Date: Tue, 11 Dec 2007 14:30:40 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trash can <thetrashcan@earthlink.net>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>
Subject: Re: Iomega ZIP-100 drive unsupported with jmicron JMB361 chip?
References: <fa.yONLBG7CMuz80f4dUP5r/5k7emw@ifi.uio.no> <475DD7FF.4030906@shaw.ca> <475EAEDD.9090905@earthlink.net> <475EC0D1.8010200@rtr.ca> <475EC163.8070305@rtr.ca> <475EDF76.4000703@earthlink.net>
In-Reply-To: <475EDF76.4000703@earthlink.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trash can wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Thanks for the note. Zip drive as only device on the bus did not work
> for me. kernel is correctly identifying the Jmicron chip.
..

So have you tried 2.6.24-rc* on that system yet, using only libata ?

> Mark Lord wrote:
>> Mark Lord wrote:
>>> I missed the early part of this thread,
>>> but here is a data point that may or may not be useful.
>>>
>>> I have an ASUS mobo here with an onboard JM363 SATA/PATA controller
>>> (verified by looking at the actual chip).
>>>
>>> It works fine when in AHCI mode with a PATA ATAPI ZIP100 drive
>>> all by itself.  No other configurations tested.
>>> This is with kernel 2.6.24-rc4-git?.
>> ..
>>
>> Oh yeah.. that's with libata controlling all drives in the system.
..
