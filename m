Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbYCDMFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbYCDMFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYCDMEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:04:51 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:36150 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYCDMEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:04:50 -0500
Message-ID: <47CD3AC8.6020300@panasas.com>
Date: Tue, 04 Mar 2008 14:04:24 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
CC: Matthew Wilcox <matthew@wil.cx>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sergio Luis <sergio@larces.uece.br>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] 2.6.25-rc1-git2: GDT SCSI: change drivers/scsi/gdth.c
 into using pci_get device
References: <47B1ADCE.40202@larces.uece.br> <1202833354.3137.19.camel@localhost.localdomain> <47B1CF45.5070407@panasas.com> <47B23033.1080100@larces.uece.br> <1202861823.3137.170.camel@localhost.localdomain> <47B2B101.3090106@panasas.com> <20080216163756.GG7657@parisc-linux.org> <47B80E65.7090504@panasas.com> <47CCFECC.8040709@suse.de>
In-Reply-To: <47CCFECC.8040709@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04 2008 at 9:48 +0200, Hannes Reinecke <hare@suse.de> wrote:
> Boaz Harrosh wrote:
>> On Sat, Feb 16 2008 at 18:37 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
>>> On Wed, Feb 13, 2008 at 10:57:37AM +0200, Boaz Harrosh wrote:
>>>> I still don't have a card for testing myself. Again anyone
>>>> wants to send me a card. Intel people anybody home?
>>> Apparently Intel sold this line of cards to Adaptec.  The copyright
>>> notice in the file backs this up:
>>>
>>>  * Copyright (C) 1995-06 ICP vortex GmbH, Achim Leubner                 *
>>>  * Copyright (C) 2002-04 Intel Corporation                              *
>>>  * Copyright (C) 2003-06 Adaptec Inc.                                   *
>>>  * <achim_leubner@adaptec.com>                                          *
>>>
>> OK I never got this guy to ping back. CCing support@adaptec.com.
>>
>> Who is the right contact person, regarding the HW that is supported
>> by the gdth driver? Form what we see in driver commit logs (above), 
>> it was transfered to  Adaptec from Intel in 2003. Is that still so?
>>
> Yes, apparently. But gdth is the driver for the rather old ICP Vortex
> range; most of which are driven by aacraid nowadays.
> I thought I had one of these beasts; will check.
> 
> But yes, this is Adaptec. Unless the person is Mark Salyzyn or Luben
> it's quite tricky to excite any response.
> 
> Cheers,
> 
> Hannes

Thanks Hannes.

I never got any response. I guess I'm not important enough.
Christoph said he has a card, that he'll send once he gets
to it. I'll wait for his card. I gave up on the Adaptec guys.

Boaz
